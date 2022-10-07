# frozen_string_literal: true

require 'simplecov'

if ENV['CI']
  require 'simplecov_json_formatter'
  SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
end
SimpleCov.start do
  add_filter 'spec/'
  add_filter '.github/'
end

require 'omniauth'
require 'omniauth-quickbooks-oauth2'
require 'webmock/rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, type: :strategy
end
