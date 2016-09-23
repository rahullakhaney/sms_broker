require 'pry'
require 'vcr'
require 'simplecov'
require 'codeclimate-test-reporter'
require 'sms_broker'
require 'webmock/rspec'
require 'support/nexmo_helpers'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new [
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

RSpec.configure do |config|
  config.include NexmoHelpers
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.hook_into :webmock
end
