# Simple client that posts a JSON message to a REST API.
class Client
  # Creates a simple JSON message.
  def create_payload(message)
    message = {
      'container' => Socket.gethostname,
      'payload' => message,
      'timestamp' => Time.now.iso8601
    }

    JSON.pretty_generate(message)
  end

  # Sends a message to the REST API.
  def send_message(message)
    headers = {
      :accept => :json,
      :content_type => :json,
    }

    resp = RestClient::Request.execute(:method => :post,
                                       :url => ENV['API_ENDPOINT'],
                                       :headers => headers,
                                       :payload => create_payload(message))
    puts "Received: #{resp.body}"
  end
end
