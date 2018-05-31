# == Class: mon_homelab::setup::influxdb
#
# === Parameters
#
class mon_homelab::setup::influxdb (
    $influx_version = $::mon_homelab::influx_version,
){

    class {'::influxdb::server':
        version             => $influx_version,
        conf_template       => 'mon_homelab/influxdb.conf.erb',
        influxdb_stderr_log => '/var/log/influxdb/influxd.log',
        config_file         => '/etc/influxdb/influxdb.conf',
    }

}
