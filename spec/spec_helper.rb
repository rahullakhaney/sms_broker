require 'pry'
require 'yaml'
require 'simplecov'
require 'codeclimate-test-reporter'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new [
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

# load service_keys.yml to ENV
yml_file = File.expand_path('../support/services_keys.yml', __FILE__)

YAML.load(File.read(yml_file)).each do |key, value|
  ENV[key] = value
end

require 'sms_broker'
require 'webmock/rspec'

require 'support/nexmo_helpers'

RSpec.configure do |config|

  config.include NexmoHelpers

end
