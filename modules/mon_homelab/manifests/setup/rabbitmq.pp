# == Class: mon_homelab::setup::rabbitmq
#
# === Parameters
#
class mon_homelab::setup::rabbitmq (
    $rabbit_admin_username = $::mon_homelab::rabbit_admin_username,
    $rabbit_admin_password = $::mon_homelab::rabbit_admin_password,
    $rabbitmq_host         = $::mon_homelab::rabbitmq_host,
    $rabbitmq_user         = $::mon_homelab::rabbitmq_user,
    $rabbitmq_password     = $::mon_homelab::rabbitmq_password,
){

    case $::osfamily {
      'Debian':{
        #echo "deb https://dl.bintray.com/rabbitmq/debian {distribution} main"
        #lsbdistcodename
        ::apt::source { "dl.bintray.com-${::lsbdistcodename}-rabbitmq":
          location => 'https://dl.bintray.com/rabbitmq/debian',
          key      => '418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB',
          repos    => 'main',
          release  => "${::lsbdistcodename}-security"
        }
        ->::apt::key { 'rabbtmq-key':
          id     => '0A9AF2115F4687BD29803A206B73A36E6026DFCA',
          source => 'https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc',
        }
        package { 'erlang':
            ensure  => installed,
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
            'NODE_IP_ADDRESS' => $rabbitmq_host,
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
