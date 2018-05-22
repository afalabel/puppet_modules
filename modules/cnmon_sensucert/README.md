# cnmon_sensucert


## Module Description

  Configura i certificati e le chiavi per le comunicazioni tra sensu e rabbitmq


## Usage

  Configurare i certificati solo per rabbitmq
```puppet
	class { 'cnmon_sensucert':
	    env => 'rabbitmq',
	}
```

  Configurare i certificati solo per sensu
```puppet
	class { 'cnmon_sensucert':
	    env => 'sensu',
	}
```

  Configurare i certificati per rabbitmq e sensu
```puppet
	class { 'cnmon_sensucert':
	    env => ['rabbitmq', 'sensu'],
	}
```