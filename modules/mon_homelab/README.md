# mon_homelab

## Module Description
   Configura un testbed completo per cnmon


## Usage


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

- RabbitMQ Management: http://<host>:15672/
- Dashboard Uchiwa:    http://<host>:3000/
- Dashboard Grafana:   http://<host>:8080/
