# == Class: mon_homelab::setup::sensu
#
# === Parameters
#
class mon_homelab::setup::sensu (
    $rabbitmq_port     = $::mon_homelab::rabbitmq_port,
    $rabbitmq_host     = $::mon_homelab::rabbitmq_host,
    $rabbitmq_user     = $::mon_homelab::rabbitmq_user,
    $rabbitmq_password = $::mon_homelab::rabbitmq_password,
    $rabbitmq_vhost    = $::mon_homelab::rabbitmq_vhost,
    $redis_host        = $::mon_homelab::redis_host,
    $redis_port        = $::mon_homelab::redis_port,
    $api_bind          = $::mon_homelab::api_bind,
    $api_host          = $::mon_homelab::api_host,
    $api_port          = $::mon_homelab::api_port,
    $api_user          = $::mon_homelab::api_user,
    $api_password      = $::mon_homelab::api_password,
    $def_subs          = $::mon_homelab::def_subs,
    $sensu_version     = $::mon_homelab::sensu_version,
    $environment_sensu = $::mon_homelab::environment_sensu,
    $sensu_server      = $::mon_homelab::sensu_server,
    $influx_srv        = $::mon_homelab::influx_srv,
    $influx_port       = $::mon_homelab::influx_port,
    $influx_sensu_usr  = $::mon_homelab::influx_sensu_usr,
    $influx_sensu_pwd  = $::mon_homelab::influx_sensu_pwd,
    $influx_sensu_db   = $::mon_homelab::influx_sensu_db,
){

    $influxdb_tags = []

    if empty($influxdb_tags) {
        $influxdb_tags_real = {}
        $client_custom = {'environment' => $environment_sensu, }
    }else{
        $influxdb_tags_real = hash($influxdb_tags)
        $client_custom = {
            'environment' => $environment_sensu,
            'influxdb'    => {
                'tags' => $influxdb_tags_real,
            },
        }
    }

    #show tag values with key = tag1    #lista tutti i valori di un tag
    #select * from "curl_timings.time_total" where tag1='value1'

    file { '/etc/sudoers.d/sensu':
        ensure => file,
        group  => 'root',
        owner  => 'root',
        mode   => '0440',
        source => 'puppet:///modules/mon_homelab/sensu.sudo',
    }

    package {['ruby-dev','g++','gcc','sysstat']:
      ensure => 'present',
    }
    ->package { ['mail', 'rest-client', 'erubis',
    'em-http-request', 'eventmachine', 'json', 'sensu-plugins-sensu',
    'sensu-plugins-process-checks','sensu-plugins-ntp',
    'sensu-plugins-cpu-checks',
    'sensu-plugins-network-checks', 'sensu-plugins-http',
    'sensu-plugins-filesystem-checks', 'sensu-plugins-io-checks',
    'sensu-plugins-memory-checks', 'sensu-plugins-load-checks',
    'sensu-plugins-disk-checks',
    'multi_json']:
        ensure   => 'present',
        provider => 'sensu_gem',
    }

    if ($sensu_server == true){
      class { '::sensu':
          server               => $sensu_server,
          api                  => true,
          purge                => true,
          rabbitmq_port        => $rabbitmq_port,
          rabbitmq_host        => $rabbitmq_host,
          rabbitmq_user        => $rabbitmq_user,
          rabbitmq_password    => $rabbitmq_password,
          rabbitmq_vhost       => $rabbitmq_vhost,
          redis_host           => $redis_host,
          redis_port           => $redis_port,
          api_bind             => $api_bind,
          api_host             => $api_host,
          api_port             => $api_port,
          api_user             => $api_user,
          api_password         => $api_password,
          subscriptions        => $def_subs,
          use_embedded_ruby    => true,
          gem_path             => '/opt/sensu/embedded/bin/gem',
          sensu_plugin_version => present,
          version              => $sensu_version,
          client_custom        => $client_custom,
      }

      file { '/etc/sensu/plugins/custom':
          recurse => true,
          purge   => true,
          owner   => 'sensu',
          group   => 'sensu',
          mode    => '0755',
          source  => 'puppet:///modules/mon_homelab/custom',
          notify  => Service['sensu-client'],
      }

      file { '/etc/sensu/conf.d/influxdb.json':
        ensure  => file,
        owner   => 'sensu',
        group   => 'sensu',
        mode    => '0755',
        content => template('mon_homelab/influxdb.json.erb'),
        notify  => [ Service['sensu-server'], Service['sensu-api'],
              Service['sensu-client'] ],
      }
      file { '/etc/sensu/conf.d/mailer.json':
        ensure  => file,
        owner   => 'sensu',
        group   => 'sensu',
        mode    => '0755',
        content => template('mon_homelab/mailer.json.erb'),
        notify  => [ Service['sensu-server'], Service['sensu-api'],
                    Service['sensu-client'] ],
              }


      sensu::extension { 'influxdb.rb':
        ensure => present,
        source => 'puppet:///modules/mon_homelab/influxdb.rb',
      }


      ########## FILTERS ##########
      $attr_recurrences_myalertlog = {
          'occurrences' => 'eval: value == 3  || value % 60 == 0',
      }

      sensu::filter { 'recurrences_myalertlog':
          attributes => $attr_recurrences_myalertlog,
      }

      $attr_recurrences_myalertlog_resolve = {
          'occurrences' => 'eval: value >= 3',
      }

      sensu::filter { 'recurrences_myalertlog_resolve':
          attributes => $attr_recurrences_myalertlog_resolve,
      }

      #######################################
      ## FILTRI PER ENV E ATTRIBUTI CUSTOM ##
      #######################################
      $attr_production = { 'client' => { 'environment' => 'prod' }, }

      sensu::filter { 'production':
          attributes => $attr_production,
      }

      sensu::filter { 'not_production':
          attributes => $attr_production,
          negate     => true,
      }


      ######################################################################
      ## IDENTIFICAZIONE ACTION RESOLVE/CREATE PER I NOTIFICATION HANDLER ##
      ######################################################################

      $attr_myalertlog_create = {
          'action' => 'create',
      }

      sensu::filter { 'myalertlog_create':
          attributes => $attr_myalertlog_create,
      }
      ############

      $attr_myalertlog_resolve = {
          'action' => 'resolve',
      }

      sensu::filter { 'myalertlog_resolve':
          attributes => $attr_myalertlog_resolve,
      }

      ########## HANDLER ##########
      $night_interval = {
          'begin' => '11PM CEST',
          'end'   => '06AM CEST',
      }

      sensu::handler { 'metrics':
          type     => 'set',
          handlers => ['influxdb'],
      }

      sensu::handler { 'mylog':
          type     => 'set',
          handlers => ['myalertlog_create', 'myalertlog_resolve', 'myalertlog_create_prod', 'myalertlog_resolve_prod'],
      }

      sensu::handler { 'myalertlog_create':
          command => 'tee -a /var/log/sensu/myalertlog_create.log',
          type    => 'pipe',
          filters => ['recurrences_myalertlog', 'myalertlog_create', 'not_production'],
      }

      sensu::handler { 'myalertlog_resolve':
          command => 'tee -a /var/log/sensu/myalertlog_resolve.log',
          type    => 'pipe',
          filters => ['recurrences_myalertlog_resolve', 'myalertlog_resolve', 'not_production'],
      }

      sensu::handler { 'myalertlog_create_prod':
          command => 'tee -a /var/log/sensu/myalertlog_create_prod.log',
          type    => 'pipe',
          filters => ['recurrences_myalertlog', 'myalertlog_create', 'production'],
      }

      sensu::handler { 'myalertlog_resolve_prod':
          command => 'tee -a /var/log/sensu/myalertlog_resolve_prod.log',
          type    => 'pipe',
          filters => ['recurrences_myalertlog_resolve', 'myalertlog_resolve', 'production'],
      }


      ########## CHECK ##########
      mon_homelab::setup::check { 'check_crond':
          command     => 'check-process.rb -p cron -C 1',
          subscribers => 'linux',
      }

      mon_homelab::setup::check { 'check_ntpd':
          command     => 'check-process.rb -p ntpd -C 1',
          subscribers => 'linux',
          handle      => false,
      }

      mon_homelab::setup::check { 'check-ntp':
          command      => 'check-ntp.rb',
          subscribers  => 'linux',
          aggregate    => undef,
          handle       => false,
          dependencies => ['check_ntpd'],
      }

      ########## METRICHE ##########
      mon_homelab::setup::metric { 'metrics-cpu':
          command     => 'metrics-cpu.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-disk':
          command     => 'metrics-disk.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-load':
          command     => 'metrics-load.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-user-pct-usage':
          command     => 'metrics-user-pct-usage.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-memory-percent':
          command     => 'metrics-memory-percent.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-memory':
          command     => 'metrics-memory.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-iostat-extended':
          command     => 'metrics-iostat-extended.rb',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-netif':
          command     => 'metrics-netif.rb --scheme `hostname -f`.netif',
          subscribers => 'linux',
      }

      mon_homelab::setup::metric { 'metrics-interface':
          command     => 'metrics-interface.rb',
          subscribers => 'linux',
      }
  }
  else{
    class { '::sensu':
      purge                => true,
      rabbitmq_port        => $rabbitmq_port,
      rabbitmq_host        => $rabbitmq_host,
      rabbitmq_user        => $rabbitmq_user,
      rabbitmq_password    => $rabbitmq_password,
      rabbitmq_vhost       => $rabbitmq_vhost,
      subscriptions        => $def_subs,
      use_embedded_ruby    => true,
      gem_path             => '/opt/sensu/embedded/bin/gem',
      sensu_plugin_version => present,
      client_custom        => $client_custom
    }
  }
}
