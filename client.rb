# Simple client that posts a JSON message to a SQS queue.
class Client
  # Creates a simple JSON message.
  def create_message(payload)
    message = {
      'container' => Socket.gethostname,
      'payload' => payload,
      'timestamp' => Time.now.iso8601
    }

    JSON.pretty_generate(message)
  end

  # Sends a message to the SQS queue.
  def send_message(payload)
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
    resp = sqs.send_message(queue_url: ENV['SQS_ENDPOINT'],
                            message_body: create_message(payload))
    puts "Sent: #{resp.message_id}"
  end
end
