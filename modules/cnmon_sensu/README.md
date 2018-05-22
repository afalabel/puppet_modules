# cnmon_sensu

## Module Description
  Modulo di interfaccia per i parametri di configurazione di sensu


##Usage

##### SERVER
```puppet
class { 'cnmon_sensu':
    server   => true,
    env_name => 'sysinfo',
    repo_source => 'http://os-server.cnaf.infn.it/distro/sensu/',
}
```

##### CLIENT
```puppet
class { 'cnmon_sensu':
    environment => 'prod',
    env_name    => 'sysinfo',
    repo_source => 'http://os-server.cnaf.infn.it/distro/sensu/',
}
```
