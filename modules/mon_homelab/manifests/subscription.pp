# == Define: mon_homelab::subscription
#
# This define manages mon_homelab subscription
#
#
define mon_homelab::subscription (
    $ensure = 'present',
    $custom = {},
){

    sensu::subscription { $name:
        ensure => $ensure,
        custom => $custom,
    }

}
