# == Define: mon_homelab::setup::metric
#
# Define di una metrica generica
#
# === Parameters
#
define mon_homelab::setup::metric (
  $ensure       = 'present',
  $interval     = 30,
  $standalone   = false,
  $command      = undef,
  $handlers     = ['metrics'],
  $subscribers  = undef,
  $type         = 'metric',
  $custom       = undef,
) {

  sensu::check { $title:
    ensure      => $ensure,
    command     => $command,
    handlers    => $handlers,
    subscribers => $subscribers,
    interval    => $interval,
    standalone  => $standalone,
    type        => $type,
    custom      => $custom,
  }

}
