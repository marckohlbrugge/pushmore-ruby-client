# frozen_string_literal: true

require "net/https"
require "ostruct"

class PushMore
  def self.configuration
    @configuration ||= OpenStruct.new
  end

  def self.configure
    yield(configuration)
  end

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

  def initialize(body, key: nil)
    @body = body
    @key = key || PushMore.configuration.api_key || ENV.fetch("PUSH_MORE_KEY")
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
