require 'time'
require 'socket'

require 'rubygems'
require 'rake'
require 'dotenv/tasks'
require 'aws-sdk'
require 'json'

require_relative 'client'
require_relative 'server'

namespace :hello do
  desc 'Simple client that posts messages to a queue'
  task :client, [:message] => :dotenv do |task, args|
    message = args[:message]

    startup_message('Sending to')
    client = Client.new

    # Send messages in an infinite loop
    loop do
      begin
        client.send_message(message)
        wait_millis

      rescue StandardError => e
        display_error(e)
      end
    end
  end

  desc 'Simple server that polls the queue for messages'
  task :server => :dotenv do
    startup_message('Receiving from')
    server = Server.new

    # Poll for messages in an infinite loop
    loop do
      begin
        server.receive_message
        wait_millis

      rescue StandardError => e
        display_error(e)
      end
    end
  end

private

  # Wait the configured number of milliseconds
  def wait_millis
    delay = ENV['SLEEP_MILLIS'].to_i / 1000
    sleep(delay)
  end

  def display_error(e)
    puts "Error: #{e.message}"
    puts e.backtrace
  end

  def startup_message(state)
    puts "#{state} SQS queue #{ENV['SQS_ENDPOINT']}"
  end
end
