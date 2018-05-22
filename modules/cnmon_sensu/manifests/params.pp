# == Class: cnmon_sensu::params
#
# This class manages cnmon_sensu parameters
#
#
class cnmon_sensu::params {

    $rabbitmq_port      = '5671'
    $rabbitmq_host      = '127.0.0.1'
    $rabbitmq_prefetch  = undef
    $redis_host         = '127.0.0.1'
    $api_bind           = '0.0.0.0'
    $api_host           = 'localhost'
    $api_port           = '4567'
    $influx_port        = '8086'
    $influx_sensu_pwd   = 'sensum3tr1csdb'
    $influx_srv_test    = '127.0.0.1'
    $enable_influx_test = false

    $environment                 = 'prod'
    $server                      = false
    $env_name                    = 'dev'
    $repo_source                 = "https://sensu.global.ssl.fastly.net/yum/\$releasever/\$basearch/"
    $client_keepalive            = {}
    $version                     = 'present'
    $rabbitmq_reconnect_on_error = true
    $redis_reconnect_on_error    = true
    $def_subs                    = ['all', 'linux']
    $influxdb_tags               = []
    $yumlock_sensu_package       = false
    $redact                      = []

    case $::osfamily {
        'RedHat': {}
        'Debian': {}
        default: {
            fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
    }
}
