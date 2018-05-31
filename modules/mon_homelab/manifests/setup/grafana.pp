# == Class: mon_homelab::setup::grafana
#
# === Parameters
#
class mon_homelab::setup::grafana (
    $grafanauser     = $::mon_homelab::grafanauser,
    $grafanapassword = $::mon_homelab::grafanapassword,
    $grafanaversion  = $::mon_homelab::grafanaversion,
){
case $::osfamily {
    'Debian' : {
      package{ ['freetype2-demos']:
        ensure => present,
      }
    }
    'RedHat' : {
      package{ ['freetype','urw-fonts']:
        ensure => present,
      }
    }
    default: { fail("${::osfamily} not supported yet") }
  }

    class { '::grafana':
        install_method => 'repo',
        version        => $grafanaversion,
        ldap_cfg       => undef,
        cfg            => {
            server   => {
                http_port => 8080,
                protocol  => 'http',
            },
            database => {
                type => 'sqlite3',
                host => '127.0.0.1:3306',
                name => 'grafana',
            },
            security => {
                admin_user     => $grafanauser,
                admin_password => $grafanapassword,
            },
            users    => {
                allow_sign_up        => false,
                allow_org_create     => false,
                auto_assign_org      => false,
                auto_assign_org_role => 'Viewer',
            },
        },
    }

}
