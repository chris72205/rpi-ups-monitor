# rpi-ups-monitor
Simple UPS Monitoring (current load in watts) on a Raspberry Pi with Network UPS Tools (NUT)

## Requirements

- NUT
- ruby/ruby-dev
- rabbitmq instance

## Installation

- clone this repo onto the Raspberry Pi that is connected to the UPS(s)
- cd into directory and run `bundle`
- copy `settings.json.sample` to `settings.json` and fill in values
- run the following commands to set up as a service:

```
$ sudo cp rpi-ups-monitor.service /etc/systemd/system
$ chmod u+x run.rb
$ sudo systemctl start rpi-ups-monitor
$ sudo systemctl status rpi-ups-monitor # this is optional, just for ensuring it started successfully
$ sudo systemctl enable rpi-ups-monitor
```

Optionally add this cronjob to update every 15 minutes:
```
*/15 * * * * git -C /home/pi/rpi-ups-monitor pull
```