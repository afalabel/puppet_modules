# == Class: cnmon_sensucert::env::sensu
#
# Esegue il setup dei certificati per sensu
#
# === Parameters
#
class cnmon_sensucert::env::sensu {

    $ssl_dir = '/etc/sensu/ssl'

    file {"${ssl_dir}/cert.pem":
        ensure  => file,
        owner   => 'sensu',
        group   => 'sensu',
        mode    => '0644',
        source  => 'puppet:///modules/cnmon_sensucert/sensu/cert.pem',
        require => File[$ssl_dir],
    }

    file {"${ssl_dir}/key.pem":
        ensure  => file,
        owner   => 'sensu',
        group   => 'sensu',
        mode    => '0400',
        source  => 'puppet:///modules/cnmon_sensucert/sensu/key.pem',
        require => File[$ssl_dir],
    }

}
