# == Class: mon_homelab::setup::uchiwa
#
# === Parameters
#
class mon_homelab::setup::uchiwa (
    $api_port        = $::mon_homelab::api_port,
    $api_user        = $::mon_homelab::api_user,
    $api_password    = $::mon_homelab::api_password,
    $uchiwa_bind     = $::mon_homelab::uchiwa_bind,
    $uchiwa_version  = $::mon_homelab::uchiwa_version,
    $uchiwa_user     = $::mon_homelab::uchiwa_user,
    $uchiwa_password = $::mon_homelab::uchiwa_password,
    $uchiwa_port     = $::mon_homelab::uchiwa_port,
){

    $repo_source_uchiwa = "http://repositories.sensuapp.org/yum/${::operatingsystemmajrelease}/\$basearch/"

    $uchiwa_api_config = [{
                            name      => 'sensu',
                            host      => '127.0.0.1',
                            ssl       => false,
                            insecure  => true,
                            port      => $api_port,
                            user      => $api_user,
                            pass      => $api_password,
                            path      => '',
                            timeout   => 5000
                        }]

    $users = [{
                'username' => $uchiwa_user,
                'password' => $uchiwa_password,
                'readonly' => false
            }]

    class { '::uchiwa':
        host                => $uchiwa_bind,
        port                => $uchiwa_port,
        users               => $users,
        refresh             => 1500,
        sensu_api_endpoints => $uchiwa_api_config,
        install_repo        => false,
        repo_source         => $repo_source_uchiwa,
        version             => $uchiwa_version,
        manage_package      => false,
        require             => Class['sensu'],
    }

}
