require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.require :default, ENV['RACK_ENV'].to_sym
Dotenv.load

require 'dotenv/tasks'

require 'time'
require 'socket'

require_relative 'client'
require_relative 'worker'

namespace :hello do
  desc 'Simple client that posts messages to a queue'
  task :client, [:message] => :dotenv do |task, args|
    message = args[:message]

    startup_message('Sending to', ENV['API_ENDPOINT'])
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

  desc 'Simple worker server that polls the queue for messages'
  task :worker => :dotenv do
    startup_message('Receiving from', ENV['SQS_ENDPOINT'])
    worker = Worker.new

    # Poll for messages in an infinite loop
    loop do
      begin
        worker.receive_message
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

  def startup_message(state, endpoint)
    puts "#{state} #{endpoint}"
  end
end
