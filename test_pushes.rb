#!/usr/bin/env ruby

require 'bundler/setup'
require 'dotenv'
require 'pushbullet'

Dotenv.load

# Initialize the client with your access token from .env
client = Pushbullet::Client.new(
  access_token: ENV['pushbullet_access_token'],
  base_path: 'https://api.pushbullet.com/v2'
)

puts "Fetching your pushes..."

# The API response wraps pushes in a 'body' key
result = client.pushes
pushes = result['body'] || []

if pushes.empty?
  puts "No pushes found."
else
  puts "Found #{pushes.length} push(es):"
  pushes.each do |push|
    title = push['title'] || push['body'] || '(no title)'
    puts "  - [#{push['type']}] #{title}"
    puts "    Created: #{push['created']}"
    puts
  end
end

puts "Done."
