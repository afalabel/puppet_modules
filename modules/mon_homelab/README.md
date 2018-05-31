# cnbebop_sensu_testbed

## Module Description
   Configura un testbed completo per cnmon


## Usage

```bash
puppet module install cnaf-cnbebop_sensu_testbed-0.1.0.tar.gz
```

```puppet
puppet apply -e "include cnbebop_sensu_testbed"
```


## SETUP INFLUX

```bash
vi /etc/influxdb/influxdb.conf
    enabled = false ---> enabled = true

service influxdb restart


influx
create user admin with password 'password' with all privileges
exit

influx -username admin -password 'password'
create database sensu_db
create user sensu_db_admin with password 'sensupasswordinflux'
grant all on sensu_db to sensu_db_admin

vi /etc/influxdb/influxdb.conf
    enabled = true ---> enabled = false

service influxdb restart
```

## ENDPOINTS

- RabbitMQ Management: http://test-sysinfo01.example.com:15672/
- Dashboard Uchiwa:    http://test-sysinfo01.example.com:3000/
- Dashboard Grafana:   http://test-sysinfo01.example.com:8080/

