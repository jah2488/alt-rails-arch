ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"
require "minitest/rails/capybara"
require "simplecov"
require "codeclimate-test-reporter"

CodeClimate::TestReporter.start
SimpleCov.start 'rails'

#Migrations
Dir[Rails.root.join('db', 'migrations', '*.rb')].each { |file| require file }

[ CreatePosts ].each do |migration|
  migration.send(:run)
end
