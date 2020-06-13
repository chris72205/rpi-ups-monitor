#!/usr/bin/env ruby

require "bunny"
require "json"

load 'nut_adapter.rb'

settings = JSON.parse File.read("settings.json")

bunny = Bunny.new(settings['amqp_url'])
bunny.start

channel = bunny.create_channel
exchange = channel.topic("sensors", :auto_delete => true)

adapter = NutAdapter.new(settings['ups_name'])

# enter loop and publish ups_data every ~30 seconds
while true do
  exchange.publish(
    {
      device_id: settings['device_id'],
      ups_name: settings['ups_name'],
      watts: adapter.current_load,
      time: Time.now.to_i
    }.to_json,
    routing_key: "ups-monitor"
  )

  sleep 30
end
