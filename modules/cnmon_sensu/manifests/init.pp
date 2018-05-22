# == Class: cnmon_sensu
#
# Modulo di interfaccia per i parametri di configurazione di sensu
#
# === Parameters
# [*rabbitmq_port*]
#   String. La porta del server rabbitmq
#   Default: 5671
#
# [*rabbitmq_host*]
#   String. L'hostname del server rabbitmq
#   Default: cnmon-broker.cr.cnaf.infn.it
#
# [*rabbitmq_prefetch*]
#   Integer. Valore del prefetch dei messaggi
#   Da utilizzare in caso di replica del server
#   Default: undef
#
# [*redis_host*]
#   String. L'hostname del server redis
#   Default: cnmon-buffer.cr.cnaf.infn.it
#
# [*api_bind*]
#   String. ip su cui fare bind delle api
#   Default: 0.0.0.0
#
# [*api_host*]
#   String. L'hostname del server delle api
#   Default: localhost
#
# [*api_port*]
#   String. La porta su cui ascoltano le api sensu
#   Default: 4567
#
# [*influx_port*]
#   String. La porta del db delle metriche
#   Default: 8086
#
# [*influx_sensu_pwd*]
#   String. La password del db in cui scrivere le metriche
#   Default: sensum3tr1cs
#
# [*influx_srv_test*]
#   String. Hostname del server delle metriche di test
#   Default: cnmon-meter-test.cr.cnaf.infn.it
#
# [*enable_influx_test*]
#   Boolean. Indica se configurare l'endpoint di test per influxdb
#   Default: false
#
# PARAMETRI SPECIFICI PER REPARTO
#
# [*environment*]
#   String. Definisce un parametro custom utilizzato nel routing delle notifiche
#   Default: prod
#   Valid values: dev, prod
#   A seconda di come si setta questo parametro le notifiche verranno trattate
#   come per produzione o non produzione
#
# [*server*]
#   Boolean. Indica se configurate sensu per agire da server
#   Default: false
#
# [*env_name*]
#   Boolean. Indica il reparto da gestire
#   Default: undef
#
# [*repo_source*]
#   String. Endpoint per popolare il baseurl nel file repo
#   Default: "https://sensu.global.ssl.fastly.net/yum/\$releasever/\$basearch/"
#
# [*client_keepalive*]
#   String. Configurazione per la gestione client keepalive
#   Default: {}
#
# [*version*]
#   String. La versione di sensu da installare
#   Default: 'present'
#
# [*rabbitmq_reconnect_on_error*]
#   Boolean. Indica se in caso di errore, deve provare a riconnettersi a rabbitmq
#   Default: true
#
# [*redis_reconnect_on_error*]
#   Boolean. Indica se in caso di errore, deve provare a riconnettersi a redis
#   Default: true
#
# [*def_subs*]
#   Array. Le subscription da usare come default
#   Default: ['all', 'linux']
#
# [*influxdb_tags*]
#   Array. Crea i tag a livello di client per influxdb sfruttando la funzione hash() delle stdlib di puppet
#   Converts an array into a hash. For example, hash(['a',1,'b',2,'c',3]) returns {'a'=>1,'b'=>2,'c'=>3}. Type: rvalue.
#   Default: []
#
# [*yumlock_sensu_package*]
#   Boolean. Indica se eseguire il lock della versione del pacchetto sensu
#   Default: false
#
# [*Redact*]
#   Array. Lista di parametri di cui fare il redact
#   Default: []
#
class cnmon_sensu (
    $rabbitmq_port               = $::cnmon_sensu::params::rabbitmq_port,
    $rabbitmq_host               = $::cnmon_sensu::params::rabbitmq_host,
    $rabbitmq_prefetch           = $::cnmon_sensu::params::rabbitmq_prefetch,
    $redis_host                  = $::cnmon_sensu::params::redis_host,
    $api_bind                    = $::cnmon_sensu::params::api_bind,
    $api_host                    = $::cnmon_sensu::params::api_host,
    $api_port                    = $::cnmon_sensu::params::api_port,
    $influx_port                 = $::cnmon_sensu::params::influx_port,
    $influx_sensu_pwd            = $::cnmon_sensu::params::influx_sensu_pwd,
    $influx_srv_test             = $::cnmon_sensu::params::influx_srv_test,
    $enable_influx_test          = $::cnmon_sensu::params::enable_influx_test,
    $environment                 = $::cnmon_sensu::params::environment,
    $server                      = $::cnmon_sensu::params::server,
    $env_name                    = $::cnmon_sensu::params::env_name,
    $repo_source                 = $::cnmon_sensu::params::repo_source,
    $client_keepalive            = $::cnmon_sensu::params::client_keepalive,
    $version                     = $::cnmon_sensu::params::version,
    $rabbitmq_reconnect_on_error = $::cnmon_sensu::params::rabbitmq_reconnect_on_error,
    $redis_reconnect_on_error    = $::cnmon_sensu::params::redis_reconnect_on_error,
    $def_subs                    = $::cnmon_sensu::params::def_subs,
    $influxdb_tags               = $::cnmon_sensu::params::influxdb_tags,
    $yumlock_sensu_package       = $::cnmon_sensu::params::yumlock_sensu_package,
    $redact                      = $::cnmon_sensu::params::redact,
) inherits cnmon_sensu::params{

    validate_re($environment, ['^dev$', '^prod$'], 'Valid environment are dev or prod')
    validate_bool($enable_influx_test, $yumlock_sensu_package)

    if empty($influxdb_tags) {
        $influxdb_tags_real = {}
        $client_custom = {'environment' => $environment, }
    }else{
        $influxdb_tags_real = hash($influxdb_tags)
        $client_custom = {
            'environment' => $environment,
            'influxdb'    => {
                'tags' => $influxdb_tags_real,
            },
        }
    }
    notice ("Invalid env_name ${env_name}")
    case $env_name {
        'homelab': {
            #PARAMETRI SPECIFICI
            $rabbitmq_user     = 'homelab'
            $rabbitmq_password = 'homelab4sswordh8qnoqQXIIJdqFdwhSWPbwMXpVkgzEP2Q0O82EZ'
            $rabbitmq_vhost    = '/homelab'
            $api_user          = 'homelabapi'
            $api_password      = 'homelab4p1user'
            $influx_sensu_usr  = 'homelab_sensu'
            $influx_sensu_db   = 'homelab_sensu_metrics'
            $redis_port        = '6379'
            $redis_password    = 'cLQMAjKiwaMLqzYJfJ1fAgkgrmr4v4qnlQJ0LVD9XjE='
            $influx_srv        = '127.0.0.1'
        }
        'test': {
            #PARAMETRI SPECIFICI PER STORAGE
            $rabbitmq_user     = 'test'
            $rabbitmq_password = 'test4sswordh8qnoqQXIIJdqFdwhSWPbwMXpVkgzEP2Q0O82EZ'
            $rabbitmq_vhost    = '/test'
            $api_user          = 'testapi'
            $api_password      = 'test4p1user'
            $influx_sensu_usr  = 'test_sensu'
            $influx_sensu_db   = 'test_sensu_metrics'
            $redis_port        = '6380'
            $redis_password    = '1fA3MNAK6wuA1t2CosO+YZJcbnlidHcskWncmVyoC0k='
            $influx_srv        = '127.0.0.1'
        }
        default: {
            fail("Invalid env_name ${env_name}")
        }
    }

    class { '::cnmon_sensucert::env::sensu': }

    if $yumlock_sensu_package {
        yum::versionlock { "1:sensu-${version}.*":
            ensure => 'present',
            before => Class['sensu'],
        }
    }

    if ($server == true){

        require ::epel

        class { '::sensu':
            repo_source                 => $repo_source,
            server                      => true,
            api                         => true,
            purge                       => true,
            rabbitmq_port               => $rabbitmq_port,
            rabbitmq_host               => $rabbitmq_host,
            rabbitmq_prefetch           => $rabbitmq_prefetch,
            rabbitmq_user               => $rabbitmq_user,
            rabbitmq_password           => $rabbitmq_password,
            rabbitmq_ssl                => true,
            rabbitmq_ssl_private_key    => '/etc/sensu/ssl/key.pem',
            rabbitmq_ssl_cert_chain     => '/etc/sensu/ssl/cert.pem',
            rabbitmq_vhost              => $rabbitmq_vhost,
            rabbitmq_reconnect_on_error => $rabbitmq_reconnect_on_error,
            redis_host                  => $redis_host,
            redis_port                  => $redis_port,
            redis_password              => $redis_password,
            redis_reconnect_on_error    => $redis_reconnect_on_error,
            api_bind                    => $api_bind,
            api_host                    => $api_host,
            api_port                    => $api_port,
            api_user                    => $api_user,
            api_password                => $api_password,
            subscriptions               => $def_subs,
            use_embedded_ruby           => true,
            gem_path                    => '/opt/sensu/embedded/bin/gem',
            sensu_plugin_version        => present,
            client_keepalive            => $client_keepalive,
            version                     => $version,
            client_custom               => $client_custom,
            redact                      => $redact,
        }

    }else{

        class { '::sensu':
            repo_source                 => $repo_source,
            purge                       => true,
            rabbitmq_port               => $rabbitmq_port,
            rabbitmq_host               => $rabbitmq_host,
            rabbitmq_user               => $rabbitmq_user,
            rabbitmq_password           => $rabbitmq_password,
            rabbitmq_ssl                => true,
            rabbitmq_ssl_private_key    => '/etc/sensu/ssl/key.pem',
            rabbitmq_ssl_cert_chain     => '/etc/sensu/ssl/cert.pem',
            rabbitmq_vhost              => $rabbitmq_vhost,
            rabbitmq_reconnect_on_error => $rabbitmq_reconnect_on_error,
            subscriptions               => $def_subs,
            use_embedded_ruby           => true,
            gem_path                    => '/opt/sensu/embedded/bin/gem',
            sensu_plugin_version        => present,
            client_keepalive            => $client_keepalive,
            version                     => $version,
            client_custom               => $client_custom,
            redact                      => $redact,
        }

    }
}
