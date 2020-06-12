#!/usr/bin/env ruby

require "bunny"
require "json"

include 'nut_adapter'

settings = JSON.parse File.read("settings.json")

bunny = Bunny.new(settings['amqp_url'])
bunny.start

channel = bunny.create_channel
exchange = channel.topic("sensors", :auto_delete => true)

adapter = NutAdapter.new(settings['device_id'])

# enter loop and publish ups_data every ~30 seconds
while true do
  exchange.publish(adapter.current_load, routing_key: "ups-monitor")

  sleep 30
end
