# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'

require 'pry-byebug' # binding.pry to debug!

# Coverage
ENV['CODECLIMATE_REPO_TOKEN'] = 'ebeb5501b6c1565ecae39466e571a52c956796eb6782caa1bfcfd24e9a99ea39'
require 'codeclimate-test-reporter'
# require 'simplecov'
CodeClimate::TestReporter.start

# SimpleCov.minimum_coverage 80
SimpleCov.start do
  # add_group 'encryption', 'lib/meshchat/encryption'
  # add_group 'models', 'lib/meshchat/models'
  # add_group 'network', 'lib/meshchat/network'
  # add_gorup 'ui', 'lib/meshchat/ui'
end
# This Gem
require 'meshchat'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |file| require file }

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec::Expectations.configuration.warn_about_potential_false_positives = false
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:all) do
    Meshchat::Configuration::AppConfig.new(
      display: MeshchatStub::Display::Null::UI
    )
  end

  config.before(:each) do
    setup_database
  end
end
