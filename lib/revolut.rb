# frozen_string_literal: true

require 'revolut/version'
require 'revolut/utils'
require 'revolut/error'
require 'revolut/client'

# Main module for gem.
module Revolut
  class << self
    def client
      @client ||= Revolut::Client.new
    end

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end
  end
end
