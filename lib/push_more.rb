# frozen_string_literal: true

require "net/https"

class PushMore
  # Send notifcations to Telegram through PushMore.io
  #
  # Example:
  #   >> PushMore.new("hello world!", key: "foobar123").deliver
  #   => true
  #
  # Arguments:
  #   body: (String)
  #   key: (String)

  WEBHOOK_BASE_URL = "https://pushmore.io/webhook/"

  def initialize(body, key: ENV.fetch("PUSH_MORE_KEY"))
    @body = body
    @key = key
  end

  def deliver
    http = Net::HTTP.new(webhook_uri.host, webhook_uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Post.new(webhook_uri.request_uri)
    request.body = @body

    response = http.request(request)

    if response.body.include? "Error"
      raise response.body
    else
      true
    end
  end

  private

  def webhook_uri
    URI.parse WEBHOOK_BASE_URL + @key
  end
end
