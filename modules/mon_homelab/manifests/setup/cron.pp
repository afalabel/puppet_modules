# == Class: mon_homelab::setup::cron
#
# === Parameters
#
class mon_homelab::setup::cron {
    service { 'cron':
      ensure => running,
      enable => true,
    }
}
