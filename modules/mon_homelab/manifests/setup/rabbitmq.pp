# == Class: mon_homelab::setup::rabbitmq
#
# === Parameters
#
class mon_homelab::setup::rabbitmq (
    $rabbit_admin_username = $::mon_homelab::rabbit_admin_username,
    $rabbit_admin_password = $::mon_homelab::rabbit_admin_password,
    $rabbitmq_user         = $::mon_homelab::rabbitmq_user,
    $rabbitmq_password     = $::mon_homelab::rabbitmq_password,
){

    case $::osfamily {
      'Debian':{
        #echo "deb https://dl.bintray.com/rabbitmq/debian {distribution} main"
        #lsbdistcodename
        ::apt::source { "dl.bintray.com-${::lsbdistcodename}-rabbitmq":
          location => 'https://dl.bintray.com/rabbitmq/debian',
          key      => '630239CC130E1A7FD81A27B140976EAF437D05B5',
          repos    => 'main',
          release  => "${::lsbdistcodename}-security"
        }
        ->::apt::key { 'rabbtmq-key':
          id     => '630239CC130E1A7FD81A27B140976EAF437D05B5',
          source => 'https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc',
        }
        package { 'erlang':
            ensure  => installed,
        }

      }
      'RedHat':{
        $erlang_version       = '20.0.4-1'
        $rabbitmq_version     = '3.6.11-1'
        $erlang_pkg_version   = "${erlang_version}.el${::operatingsystemmajrelease}.centos"
        $rabbbimq_pkg_version = "${rabbitmq_version}.el${::operatingsystemmajrelease}"
        yumrepo { 'rabbitmq_erlang':
            baseurl         => "https://packagecloud.io/rabbitmq/erlang/el/\$releasever/\$basearch",
            failovermethod  => 'priority',
            enabled         => '1',
            repo_gpgcheck   => '1',
            gpgcheck        => '0',
            gpgkey          => 'https://packagecloud.io/rabbitmq/erlang/gpgkey',
            sslverify       => '1',
            sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt',
            metadata_expire => '300',
            descr           => 'rabbitmq_erlang',
        }

        yumrepo { 'rabbitmq_erlang-source':
            baseurl         => "https://packagecloud.io/rabbitmq/erlang/el/\$releasever/SRPMS",
            failovermethod  => 'priority',
            enabled         => '1',
            repo_gpgcheck   => '1',
            gpgcheck        => '0',
            gpgkey          => 'https://packagecloud.io/rabbitmq/erlang/gpgkey',
            sslverify       => '1',
            sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt',
            metadata_expire => '300',
            descr           => 'rabbitmq_erlang-source',
        }

        package { 'erlang':
            ensure  => $erlang_pkg_version,
            require => [ Yumrepo['rabbitmq_erlang'], Yumrepo['rabbitmq_erlang-source'] ],
        }
        ->yumrepo { 'rabbitmq':
            ensure   => present,
            name     => 'rabbitmq_rabbitmq-server',
            baseurl  => "https://packagecloud.io/rabbitmq/rabbitmq-server/el/${::operatingsystemmajrelease}/\$basearch",
            gpgkey   => 'https://www.rabbitmq.com/rabbitmq-release-signing-key.asc',
            enabled  => 1,
            gpgcheck => 1,
        }
      }
      default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
      }
    }
    ->class { '::rabbitmq':
        ssl                   => false,
        delete_guest_user     => true,
        node_ip_address       => '0.0.0.0',
        port                  => 5672,
        environment_variables => {
            'NODE_IP_ADDRESS' => '127.0.0.1',
            'NODE_PORT'       => '5672',
        },
        management_ssl        => false,
        config_cluster        => false,
    }
    ->rabbitmq_user { $rabbit_admin_username:
        admin    => true,
        password => $rabbit_admin_password,
    }
    ->rabbitmq_user { $rabbitmq_user:
        admin    => false,
        password => $rabbitmq_password,
        tags     => ['management'],
    }
    ->rabbitmq_vhost { "/${rabbitmq_user}":
        ensure => present,
    }
    ->rabbitmq_user_permissions { "${rabbitmq_user}@/${rabbitmq_user}":
        configure_permission => '.*',
        read_permission      => '.*',
        write_permission     => '.*',
    }
    ->rabbitmq_policy { "ha-sensu@/${rabbitmq_user}":
        pattern    => '^(results$|keepalives$)',
        priority   => 0,
        applyto    => 'all',
        definition => {
            'ha-mode'      => 'all',
            'ha-sync-mode' => 'automatic',
        },
    }

}
