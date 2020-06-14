#!/usr/bin/env ruby

require "bunny"
require "json"

load 'nut_adapter.rb'

settings = JSON.parse File.read("settings.json")

bunny = Bunny.new(
  settings['amqp_url'],
  {
    client_properties: {
      connection_name: settings['device_id']
    }
  }
)
bunny.start

channel = bunny.create_channel
exchange = channel.topic("sensors", :auto_delete => true)

adapter = NutAdapter.new(settings['ups_name'])

lastSend = Time.now
readings = []

while true do
  # check if it's been a minute since we last sent anything
  if(lastSend < (Time.now - 60) && readings.any?)
    # collect average
    average = readings.sum / readings.count

    # publish average
    exchange.publish(
      {
        device_id: settings['device_id'],
        ups_name: settings['ups_name'],
        watts: average,
        time: Time.now.to_i
      }.to_json,
      routing_key: "power"
    )

    # reset variables
    readings = []
    lastSend = Time.now
  end

  # collect current_load value
  readings << adapter.current_load

  sleep 5
end
