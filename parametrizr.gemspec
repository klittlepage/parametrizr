# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parametrizr/version'

Gem::Specification.new do |spec|
  spec.name          = 'parametrizr'
  spec.version       = Parametrizr::VERSION
  spec.authors       = ['Kelly Littlepage']
  spec.summary       = 'Context based strong parameters for rails'
  spec.description   = 'Flexible, context based strong parameters'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 3.0.0'
  spec.add_dependency 'actionpack', '>= 3.0.0'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '>=2.0.0'
  spec.add_development_dependency 'rubocop', '~> 0.28.0'
  spec.add_development_dependency 'simplecov', '~> 0.9.1'
end
