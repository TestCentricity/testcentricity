# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testcentricity/version'

Gem::Specification.new do |spec|
  spec.name          = 'testcentricity'
  spec.version       = TestCentricity::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.7.5'
  spec.authors       = ['A.J. Mrozinski']
  spec.email         = ['testcentricity@gmail.com']
  spec.summary       = %q{A Page Object Model Framework for desktop/mobile web and native mobile app testing}
  spec.description   = '
    The TestCentricity™ core framework for native mobile iOS and Android apps and desktop/mobile web testing implements a Page Object
    Model DSL for use with Cucumber, Appium, Capybara, and Selenium-Webdriver v4.x. The gem also facilitates the configuration of the
    appropriate Appium capabilities required to establish a connection with locally or cloud (using BrowserStack, Sauce Labs, or
    TestingBot services) hosted iOS or Android devices or simulators. For more information on desktop/mobile web testing with this
    gem, refer to docs for the TestCentricity™ Web gem (https://www.rubydoc.info/gems/testcentricity_web).'
  spec.homepage      = 'https://github.com/TestCentricity/testcentricity'
  spec.license       = 'BSD-3-Clause'
  spec.metadata = {
    'changelog_uri' => 'https://github.com/TestCentricity/testcentricity/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/testcentricity'
  }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.requirements  << 'Appium, TestCentricity Web'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'cuke_modeler', '~> 3.0'
  spec.add_development_dependency 'curb'
  spec.add_development_dependency 'json'
  spec.add_development_dependency 'parallel_tests'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'require_all', '=1.5.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'simplecov', ['~> 0.18']
  spec.add_development_dependency 'yard', ['>= 0.9.0']

  spec.add_runtime_dependency 'appium_lib'
  spec.add_runtime_dependency 'testcentricity_web', '>= 4.2.2'
  spec.add_runtime_dependency 'test-unit'
end
