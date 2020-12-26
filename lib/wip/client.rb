# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "wip"
require "wip/auth"

class Wip::Client
  API_ENDPOINT = "https://wip.co/graphql"

  attr_reader :api_key, :json, :response

  def initialize(api_key: Wip::Auth.api_key)
    @api_key = api_key
  end

  def request(query)
    uri = URI.parse(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = { query: query }.to_json
    @response = http.request(request)

    @json = JSON.parse(@response.body)
    if @json.has_key? "errors"
      raise @json["errors"].first["message"]
    end
    @json
  end

  def header
    {
      "Authorization": "bearer #{@api_key}",
      "Content-Type": "application/json"
    }
  end

  def data(key)
    json["data"][key] if json
  end
end
