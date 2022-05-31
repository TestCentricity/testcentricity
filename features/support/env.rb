# frozen_string_literal: true

require 'capybara/cucumber'
require 'parallel_tests'
require 'require_all'
require 'simplecov'
require 'testcentricity_web'
require 'testcentricity'

include TestCentricity

SimpleCov.command_name("Features-#{ENV['PLATFORM']}-#{Time.now.strftime('%Y%m%d%H%M%S%L')}")

require_relative 'world_data'
require_relative 'world_pages'

require_rel 'data'
require_rel 'shared_components'

# conditionally require page and section objects based on target platform
case ENV['PLATFORM'].downcase.to_sym
when :ios
  require_rel 'ios'
when :android
  require_rel 'android'
when :web
  require_rel 'web'
else
  raise "Platform unknown. Please specify the target test platform using '-p ios', '-p android', or '-p web' in the command line"
end

$LOAD_PATH << './lib'

# set the default locale and auto load all translations from config/locales/*.rb,yml.
ENV['LOCALE'] = 'en-US' unless ENV['LOCALE']
ENV['LANGUAGE'] = 'en' unless ENV['LANGUAGE']
I18n.load_path += Dir['config/locales/*.{rb,yml}']
I18n.default_locale = ENV['LOCALE']
I18n.locale = ENV['LOCALE']
Faker::Config.locale = ENV['LOCALE']

# instantiate all data objects and target test environment
include WorldData
environs.find_environ(ENV['TEST_ENVIRONMENT'], :yaml)
WorldData.instantiate_data_objects

# instantiate all page objects
include WorldPages
WorldPages.instantiate_page_objects

# connect to appropriate driver (WebDriver or Appium) based on target platform
case ENV['PLATFORM'].downcase.to_sym
when :web
  # establish connection to WebDriver and target web browser
  Webdrivers.cache_time = 86_400
  WebDriverConnect.initialize_web_driver
when :ios, :android
  AppiumConnect.initialize_appium
end

# set TestCentricity's default max wait time to 20 seconds
Environ.default_max_wait_time = 20
