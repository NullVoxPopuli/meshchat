# -*- encoding: utf-8 -*-

# allows bundler to use the gemspec for dependencies
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)


require 'meshchat/version'

Gem::Specification.new do |s|
  s.name        = 'meshchat'
  s.version     = MeshChat::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['L. Preston Sego III']
  s.email       = 'LPSego3+dev@gmail.com'
  s.homepage    = 'https://github.com/NullVoxPopuli/meshchat'
  s.summary     = "MeshChat-#{MeshChat::VERSION}"
  s.description = 'MeshChat core implementation written in ruby.'

  s.files        = Dir['CHANGELOG.md', 'LICENSE' 'MIT-LICENSE', 'README.md', 'lib/**/*']
  s.require_path = 'lib'

  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.required_ruby_version = '>= 2.3.0'

  s.add_runtime_dependency 'sqlite3',             '>= 1.3.11'
  s.add_runtime_dependency 'activerecord',        '>= 5.0.0.beta3'
  s.add_runtime_dependency 'activesupport',       '>= 5.0.0.beta3'
  s.add_runtime_dependency 'colorize',            '>= 0.7.7'
  s.add_runtime_dependency 'awesome_print',       '>= 1.6.1'
  s.add_runtime_dependency 'eventmachine',        '>= 1.2.0.1'
  s.add_runtime_dependency 'em-http-server',      '>= 0.1.8'
  s.add_runtime_dependency 'em-http-request',     '>= 1.1.3'
  s.add_runtime_dependency 'action_cable_client', '>= 1.2.0'
  s.add_runtime_dependency 'i18n',                '>= 0.7.0'


  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'em-websocket'
end
