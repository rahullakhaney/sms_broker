# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sms_broker/version'

Gem::Specification.new do |gem|
  gem.name          = 'sms_broker'
  gem.version       = SmsBroker::VERSION
  gem.authors       = ['Streetbees Dev Team']
  gem.email         = ['dev@streetbees.com']
  gem.description   = %q{sms_broker}
  gem.summary       = %q{Sms Broker}
  gem.homepage      = 'https://github.com/streetbees/sms_broker'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'nexmo', '~> 4.2'
  gem.add_runtime_dependency 'compel', '~> 0.5'
  gem.add_runtime_dependency 'twilio-ruby', '~> 4.11'

  gem.add_development_dependency 'webmock', '~> 2.0'
  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'rake', '~> 0'
  gem.add_development_dependency 'pry', '~> 0'
end
