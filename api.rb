require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.require :default, ENV['RACK_ENV'].to_sym
Dotenv.load

# Simple REST API that posts messages to a SQS Queue.
class HelloWorldApi < Sinatra::Base
  set :root, File.dirname(__FILE__)

  before do
    content_type 'application/json'
  end

  # Simple health check for load balancer.
  get '/' do
    { 'heartbeat' => true }.to_json
  end

  # Accept messages and post to SQS queue.
  post '/' do
    resp = {}

    begin
      resp['message_id'] = post_message(request.body.read)
      status 202 # Accepted
      resp.to_json

    rescue StandardError => e
      status 500
      resp['error'] = e.message
    end

    resp.to_json
  end

  # Post a message to the SQS queue.
  def post_message(message_json)
    sqs = Aws::SQS::Client.new
    resp = sqs.send_message(queue_url: ENV['SQS_ENDPOINT'],
                            message_body: message_json)
    resp.message_id
  end
end
