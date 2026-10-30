# frozen_string_literal: true

source 'https://rubygems.org'

group :test do
  gem 'codecov', require: false
  # faraday 2.14.3 calls JSON.parse(body, opts) with a positional options hash,
  # which json 3.0 no longer accepts.
  gem 'json', '< 3'
end

# Specify your gem's dependencies in revolut.gemspec
gemspec
