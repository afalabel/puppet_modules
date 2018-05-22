class{ '::cnmon_sensu':
  server      =>  hiera('cnmon_sensu::server'),
  environment => 'prod',
  env_name    => 'homelab',
}

$uchiwa_api_config = [{
                        name      => 'HOMELAB',
                        host      => 'localhost',
                        ssl       => false,
                        insecure  => true,
                        port      => '4567',
                        user      => 'homelabapi',
                        pass      => 'homelab4p1user',
                        path      => '',
                        timeout   => 5000
                    }]

$users = [{
  'username' => 'admin',
  'password' => 'd4shb0ard',
  'readonly' => false,
  }]

class{ '::uchiwa':
  host                => '192.168.35.11',
  port                => 3000,
  users               => $users,
  refresh             => 1500,
  sensu_api_endpoints => $uchiwa_api_config,
  install_repo        => false,
  repo_source         => "http://repositories.sensuapp.org/yum/${::operatingsystemmajrelease}/\$basearch/",
  version             => 'present',
}

hiera_include(classes)
