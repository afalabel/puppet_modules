# == Class: cnmon_sensucert::params
#
# This class manages cnmon_sensucert parameters
#
#
class cnmon_sensucert::params {

    $env = []

    case $::osfamily {
        'RedHat': {}
        default: {
            fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
    }
}
