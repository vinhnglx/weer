# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tempo/version'

Gem::Specification.new do |spec|
  spec.name          = 'tempo'
  spec.version       = Tempo::VERSION
  spec.authors       = ['Vinh Nguyen']
  spec.email         = ['vinh.nglx@gmail.com']

  spec.summary       = %q{Display the weather information of your city.}
  spec.description   = %q{Display the weather information of your city.}
  spec.homepage      = 'http://todayifoundout.net'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'webmock'

  # Add runtime dependencies
  spec.add_dependency 'thor'
  spec.add_dependency 'httparty'
  spec.add_dependency 'terminal-table'
end
