ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# require 'rails/test_help'

FIXTURES_DIRECTORY  = File.join(File.dirname(__FILE__), "/fixtures")
RAILS_APP_DIRECTORY = File.join(File.dirname(__FILE__), "../app")