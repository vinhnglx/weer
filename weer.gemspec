# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weer/version'

Gem::Specification.new do |spec|
  spec.name          = 'weer'
  spec.version       = Weer::VERSION
  spec.authors       = ['Vinh Nguyen']
  spec.email         = ['vinh.nglx@gmail.com']

  spec.summary       = %q{Display the weather information of your city.}
  spec.description   = %q{Display the weather information of your city.}
  spec.homepage      = 'http://todayifoundout.net'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + Dir['bin/*']
  spec.executables   = 'weer'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'coveralls'

  # Add runtime dependencies
  spec.add_dependency 'thor'
  spec.add_dependency 'httparty'
  spec.add_dependency 'terminal-table'
  spec.add_dependency 'rainbow'
end
