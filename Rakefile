require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rake'
require 'rspec/core/rake_task'
require 'simplecov'
require 'yard'


desc 'Run required specs'
RSpec::Core::RakeTask.new(:required_specs) do |t|
  t.rspec_opts = '--tag required'
end


desc 'Run web specs'
RSpec::Core::RakeTask.new(:web_specs) do |t|
  t.rspec_opts = '--tag web'
end


desc 'Run Cucumber features on iOS simulator'
Cucumber::Rake::Task.new(:ios_sim) do |t|
  t.profile = 'ios_sim'
end


desc 'Run Cucumber features on Android simulator'
Cucumber::Rake::Task.new(:android_sim) do |t|
  t.profile = 'android_sim'
end


desc 'Run required specs and Cucumber features'
task required: [:required_specs, :android_sim, :ios_sim]


desc 'Run all specs'
task all_specs: [:required_specs, :web_specs]


desc 'Run all specs and Cucumber features'
task all: [:required_specs, :web_specs, :android_sim, :ios_sim]


desc 'Update HTML docs'
YARD::Rake::YardocTask.new(:docs) do |t|
  t.files = ['lib/**/*.rb']
end


desc 'Build and release new version'
task :release do
  version = TestCentricity::VERSION
  puts "Releasing version #{version} of TestCentricity gem, y/n?"
  exit(1) unless $stdin.gets.chomp == 'y'
  sh 'gem build testcentricity.gemspec && ' \
     "gem push testcentricity-#{version}.gem"
end


desc 'Update docs, build gem, and push to RubyGems'
task ship_it: [:docs, :release]
