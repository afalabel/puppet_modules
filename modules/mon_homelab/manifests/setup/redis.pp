# == Class: mon_homelab::setup::redis
#
# === Parameters
#
class mon_homelab::setup::redis (
    $redis_port = $::mon_homelab::redis_port,
){

    class { '::redis::install':
        redis_version => 'stable',
    }

    $redis_run_dir = '/var/run/redis'
    $instance_name = "instance_${redis_port}"

    file { $redis_run_dir:
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Service["redis-server_${instance_name}"],
    }

    ::redis::server { $instance_name:
        redis_memory        => '512000kb',
        redis_ip            => '0.0.0.0',
        redis_port          => $redis_port,
        redis_nr_dbs        => 16,
        save                => [[900, 1], [300, 10], [60, 10000]],
        aof_rewrite_minsize => '64mb',
        redis_dir           => '/var/lib/redis',
        manage_logrotate    => false,
        redis_run_dir       => $redis_run_dir,
    }

}
