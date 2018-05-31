puppet  apply --hiera_config=/etc/puppetlabs/code/environments/production/hiera.yaml  /etc/puppetlabs/code/environments/production/test2.com.pp
puppet  apply --hiera_config=/etc/puppetlabs/code/environments/production/hiera.yaml --basemodulepath=/etc/puppetlabs/code/environments/production/modules  /etc/puppetlabs/code/environments/production/test2.com.pp

/etc/puppetlabs/code/environments/production/modules
├── maestrodev-wget (v1.7.3)
├─┬ puppet-network (v0.9.0)
│ ├── puppetlabs-stdlib (v4.25.1)
│ ├── puppet-filemapper (v2.1.0)
│ ├── puppet-boolean (v1.1.0)
│ └── camptocamp-kmod (v2.2.0)
├─┬ cnaf-mon_homelab (v0.1.1)
│ ├─┬ sensu-sensu (v2.53.0)
│ │ └── lwf-remote_file (v1.1.3)
│ ├── stahnma-epel (v1.2.2)
│ ├─┬ garethr-erlang (v0.3.0)
│ │ └── puppetlabs-apt (v2.4.0)
│ ├─┬ puppet-rabbitmq (v8.2.2)
│ │ └── puppet-archive (v2.3.0)
│ ├── dwerder-redis (v1.9.0)
│ ├── yelp-uchiwa (v2.0.0)
│ ├── golja-influxdb (v4.0.0)
│ ├── puppet-grafana (v4.2.0)
│ └── yo61-logrotate (v1.4.0)
├── cnaf-cnmon_sensucert (v0.1.0)
├── garethr-docker (v5.3.0)
└── puppet-staging (v1.0.7)
