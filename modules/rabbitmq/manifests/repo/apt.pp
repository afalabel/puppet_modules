# requires
#   puppetlabs-apt
#   puppetlabs-stdlib
class rabbitmq::repo::apt(
  String $location               = 'https://dl.bintray.com/rabbitmq/debian/dists',
  String $repos                  = 'main',
  Boolean $include_src           = false,
  String $key                    = '4E30C6342FB4AF5C6334233079A1D640D80A61F0',
  String $key_source             = $rabbitmq::package_gpg_key,
  Optional[String] $key_content  = $rabbitmq::key_content,
  Optional[String] $architecture = undef,
  ) {

  $pin = $rabbitmq::package_apt_pin

  # ordering / ensure to get the last version of repository
  Class['rabbitmq::repo::apt']
  -> Class['apt::update']

  $osname = downcase($::facts['os']['lsb']['distcodename'])
  apt::source { 'rabbitmq':
    ensure       => present,
    location     => "${location}/${osname}",
    repos        => $repos,
    include      => { 'src' => $include_src },
    key          => {
      'id'      => $key,
      'source'  => $key_source,
      'content' =>  $key_content,
    },
    architecture => $architecture,
  }

  if $pin {
    apt::pin { 'rabbitmq':
      packages => '*',
      priority => $pin,
      origin   => 'packagecloud.io',
    }
  }
}
