class{ '::mon_homelab': }
class { 'ntp':
  servers  => [ 'ntp.ubuntu.com' ],
  restrict => ['127.0.0.1'],
}
lookup(classes)
