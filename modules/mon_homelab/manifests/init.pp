# == Class: mon_homelab
#
# Configura un testbed completo per cnmon
#
# === Parameters
#
class mon_homelab inherits mon_homelab::params{

    include ::epel

    $rabbit_admin_username = 'admin'
    $rabbit_admin_password = 'password'
    $rabbitmq_port         = '5672'
    $rabbitmq_host         = '127.0.0.1'
    $rabbitmq_user         = 'sensu'
    $rabbitmq_password     = 'sensu'
    $rabbitmq_vhost        = '/sensu'
    $redis_host            = '127.0.0.1'
    $redis_port            = '6379'
    $api_bind              = '0.0.0.0'
    $api_host              = 'localhost'
    $api_port              = 4567
    $api_user              = 'sensu'
    $api_password          = 'sensu'
    $def_subs              = ['all', 'linux']
    $sensu_server          = lookup('sensu_server')
    $environment_sensu     = 'prod'
    $sensu_version         = '0.26.5-2'
    $uchiwa_bind           = lookup('server_ip')
    $uchiwa_version        = '0.22.0-1'
    $uchiwa_user           = 'admin'
    $uchiwa_password       = 'd4shb0ard'
    $uchiwa_port           = 3000
    $influx_srv            = '127.0.0.1'
    $influx_port           = '8086'
    $influx_sensu_usr      = 'sensu_db_admin'
    $influx_sensu_pwd      = 'sensupasswordinflux'
    $influx_sensu_db       = 'sensu_db'
    $influx_version        = '1.5.2-1'
    $grafanauser           = 'admin'
    $grafanapassword       = 'password'
    $grafanaversion        = '5.1.3'


    class {'::mon_homelab::setup::rabbitmq': }
    class {'::mon_homelab::setup::redis': }
    class {'::mon_homelab::setup::sensu': }
    class {'::mon_homelab::setup::uchiwa': }
    class {'::mon_homelab::setup::influxdb': }
    class {'::mon_homelab::setup::grafana': }

}
