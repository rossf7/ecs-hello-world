# Simple server that polls a SQS queue for messages, displays the
# contents and deletes the message.
class Server
  # Display dates nicely
  DATE_FORMAT = '%e %b %Y %H:%M:%S %z'

  # Display dates in human friendly format.
  def format_date(raw_timestamp)
    timestamp = Date.parse(raw_timestamp)
    timestamp.strftime(DATE_FORMAT)
  end

  # Outputs the formatted message to stdout.
  def display_message(message_id, message_body)
    message = JSON.parse(message_body)

    container = message['container']
    payload = message['payload']
    timestamp = format_date(message['timestamp'])

    puts "Received: #{message_id}"
    puts "Container #{container} said '#{payload}' at #{timestamp}"
  end

  # Displays the message contents and then deletes it.
  def process_message(message)
    display_message(message.message_id, message.body)

    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
    sqs.delete_message(queue_url: ENV['SQS_ENDPOINT'],
                       receipt_handle: message.receipt_handle)
  end

  # Polls the SQS queue and processes the first message in the queue.
  def receive_message
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
    resp = sqs.receive_message(queue_url: ENV['SQS_ENDPOINT'])

    if resp.messages.count > 0
      process_message(resp.messages[0])
    end
  end
end
