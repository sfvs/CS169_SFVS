require "codeclimate-test-reporter"
ENV['CODECLIMATE_REPO_TOKEN'] = "02f781b1561c0fe3dc97d44550ccaecdc7df4ceb6224743bb6e8f89fdce7b0a0"
CodeClimate::TestReporter.start
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
