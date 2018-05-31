# == Class: mon_homelab::params
#
# This class manages mon_homelab parameters
#
#
class mon_homelab::params {

    case $::osfamily {
        'RedHat': {}
        'Debian': {}
        default: {
            fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
    }

    if versioncmp($::operatingsystemmajrelease, '6') < 0 {
        fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
}
