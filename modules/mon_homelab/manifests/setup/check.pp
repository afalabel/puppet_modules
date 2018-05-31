# == Define: mon_homelab::setup::check
#
# Define di un check generico
#
# === Parameters
#
define mon_homelab::setup::check (
    $ensure              = 'present',
    $interval            = 60,
    $standalone          = false,
    $timeout             = 30,
    $refresh             = 59,
    $occurrences         = 3,
    $command             = undef,
    $handlers            = ['mylog'],
    $subscribers         = undef,
    $dependencies        = undef,
    $low_flap_threshold  = 20,
    $high_flap_threshold = 60,
    $aggregate           = undef,
    $handle              = undef,
    $subdue              = undef,
    $custom              = undef,
) {

    sensu::check { $title:
        ensure              => $ensure,
        command             => $command,
        handlers            => $handlers,
        subscribers         => $subscribers,
        dependencies        => $dependencies,
        interval            => $interval,
        standalone          => $standalone,
        timeout             => $timeout,
        refresh             => $refresh,
        occurrences         => $occurrences,
        low_flap_threshold  => $low_flap_threshold,
        high_flap_threshold => $high_flap_threshold,
        aggregate           => $aggregate,
        handle              => $handle,
        subdue              => $subdue,
        custom              => $custom,
    }

}
