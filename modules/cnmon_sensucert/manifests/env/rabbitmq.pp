# == Class: cnmon_sensucert::env::rabbitmq
#
# Esegue il setup dei certificati per rabbitmq
#
# === Parameters
#
class cnmon_sensucert::env::rabbitmq{

    $ssl_dir = '/etc/rabbitmq/ssl'

    file {"${ssl_dir}/cacert.pem":
        ensure  => file,
        owner   => 'rabbitmq',
        group   => 'rabbitmq',
        mode    => '0644',
        source  => 'puppet:///modules/cnmon_sensucert/rabbitmq/cacert.pem',
        require => File[$ssl_dir],
    }

    file {"${ssl_dir}/cert.pem":
        ensure  => file,
        owner   => 'rabbitmq',
        group   => 'rabbitmq',
        mode    => '0644',
        source  => 'puppet:///modules/cnmon_sensucert/rabbitmq/cert.pem',
        require => File[$ssl_dir],
    }

    file {"${ssl_dir}/key.pem":
        ensure  => file,
        owner   => 'rabbitmq',
        group   => 'rabbitmq',
        mode    => '0400',
        source  => 'puppet:///modules/cnmon_sensucert/rabbitmq/key.pem',
        require => File[$ssl_dir],
    }

}
