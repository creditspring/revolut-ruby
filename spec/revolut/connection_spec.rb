# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Revolut::Connection do
  let(:client) { Revolut::Client.new(api_key: 'test_key') }

  it 'raises Revolut error for a mapped status' do
    stub_request(:get, "#{base_url}/accounts").to_return(status: 401)

    expect { client.accounts }.to raise_error(Revolut::Unauthorized)
  end

  it 'raises the Faraday timeout when Revolut does not answer' do
    stub_request(:get, "#{base_url}/accounts").to_raise(Net::ReadTimeout)

    expect { client.accounts }.to raise_error(Faraday::TimeoutError)
  end

  it 'raises the Faraday server error for a status with no Revolut error class' do
    stub_request(:post, "#{base_url}/pay").to_return(status: 502)

    expect { client.pay(amount: 1) }.to raise_error(Faraday::ServerError)
  end
end
