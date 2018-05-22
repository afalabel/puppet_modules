# == Class: cnmon_sensucert
#
# Configura i certificati e le chiavi per le comunicazioni tra sensu e rabbitmq
#
# === Parameters
#
# [*env*]
#   Array. Array di setup da fare (fa riferimento ai file sotto la dir env)
#   Default: []
#
class cnmon_sensucert (
    $env = $::cnmon_sensucert::params::env,
)inherits cnmon_sensucert::params{

    cnmon_sensucert::setup { $env: }

}
