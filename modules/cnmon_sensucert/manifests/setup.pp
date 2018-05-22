# == Define: cnmon_sensucert::setup
#
# Chiama i setup da eseguire
#
# === Parameters
#
define cnmon_sensucert::setup {
    class { "cnmon_sensucert::env::${title}": }
}