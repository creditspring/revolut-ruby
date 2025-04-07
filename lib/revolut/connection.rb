# frozen_string_literal: true

require 'faraday'
require 'faraday/mashify'
require 'json'

require 'revolut/mash'

module Revolut
  # A class responsible for connecting to Revolut API and making requests.
  class Connection
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def get(path, options = {})
      request(:get, path, options).body
    rescue Faraday::Error => e
      error = Revolut::Error.from_response(e.response)
      raise error if error
    end

    def post(path, options = {})
      request(:post, path, {}, options).body
    rescue Faraday::Error => e
      error = Revolut::Error.from_response(e.response)
      raise error if error
    end

    def delete(path, options = {})
      request(:delete, path, options).body
    rescue Faraday::Error => e
      error = Revolut::Error.from_response(e.response)
      raise error if error
    end

    private

    def request(method, path, query_params = {}, body_params = {})
      connection.send(method) do |request|
        request.url(path, query_params)
        add_request_headers!(request)

        request.body = body_params.to_json if Revolut::Utils.present?(body_params)
      end
    end

    def add_request_headers!(request)
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'

      return unless client.config.api_key

      request.headers['Authorization'] = "Bearer #{client.config.api_key}"
    end

    def connection
      Faraday.new(connection_options) do |builder|
        builder.response :raise_error, include_request: true
        builder.request :json
        builder.response :mashify
        builder.response :json
      end
    end

    def connection_options
      {
        headers: { user_agent: client.config.user_agent },
        url: client.config.url
      }
    end
  end
end
