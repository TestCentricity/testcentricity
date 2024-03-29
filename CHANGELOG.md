# CHANGELOG
All notable changes to this project will be documented in this file.


## [3.1.1] - 04-AUGUST-2022

### Fixed
* `AppiumConnect.available_contexts` now correctly returns a list of native app and web contexts when testing hybrid apps 
with WebViews on iOS simulators.


## [3.1.0] - 02-AUGUST-2022

### Added
* The `DRIVER` Environment Variable is now used to specify the `appium`, `browserstack`, `saucelabs`, `testingbot`,
  or `lambdatest` driver.

* ### Changed
* The `WEB_BROWSER` Environment Variable is no longer used to specify the `appium`, `browserstack`, `saucelabs`, `testingbot`,
  or `lambdatest` driver.

### Updated
* Incorporated all changes from the [TestCentricity™ Web gem](https://rubygems.org/gems/testcentricity_web) version 4.3.0, which is
  bundled with this gem.


## [3.0.6] - 21-JUNE-2022

### Fixed
* `AppButton.get_caption` correctly returns captions of React Native buttons on Android platform where button caption object
hierarchy is `//android.widget.Button/android.widget.ViewGroup/android.widget.TextView`.


## [3.0.5] - 12-JUNE-2022

### Fixed
* Fixed `gemspec` to no longer include specs and Cucumber tests as part of deployment package for the gem.

### Updated
* Incorporated all changes from the [TestCentricity™ Web gem](https://rubygems.org/gems/testcentricity_web) version 4.2.6, which is
  bundled with this gem.


## [3.0.4] - 02-JUNE-2022

### Added
* Added `AppUIElement.wait_until_enabled` method.

### Updated
* Incorporated all changes from the [TestCentricity™ Web gem](https://rubygems.org/gems/testcentricity_web) version 4.2.4, which is
  bundled with this gem.


## [3.0.3] - 30-MAY-2022

### Added
* Added `AppAlert.await_and_respond` method.


## [3.0.2] - 26-MAY-2022

### Fixed
* Added runtime dependencies `curb` and `json` to gemspec.
* Fixed CHANGELOG url in gemspec.


## [3.0.1] - 26-MAY-2022

### Added
* Added support for testing on cloud hosted iOS and Android simulators and real devices on BrowserStack, SauceLabs, and TestingBot services.
* `ScreenObject.load_page` method adds support for using deep links to directly load screens/pages of native apps.
* `AppiumConnect.upload_app` method adds support for uploading native apps to BrowserStack and TestingBot services prior to running tests.

### Updated
* Incorporated all changes from the [TestCentricity™ Web gem](https://rubygems.org/gems/testcentricity_web) version 4.2.2, which is
bundled with this gem.

### Changed
* Ruby version 2.7 or greater is required.


## [2.4.3] - 2018-04-11

### Changed
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.4.1] - 2018-03-27

### Added
* Added device profiles for iPad (iOS 10) with MS Edge browser.


## [2.4.0] - 2018-03-25

### Changed
* Updated `TestCentricity::WebDriverConnect.initialize_web_driver` method to read the `APP_FULL_RESET`, `APP_NO_RESET`, and `NEW_COMMAND_TIMEOUT` Environment
Variables and set the corresponding `fullReset`, `noReset`, and `newCommandTimeout` Appium capabilities for iOS and Android physical devices and simulators.
Also reads the `WDA_LOCAL_PORT` Environment Variable and sets the `wdaLocalPort` Appium capability for iOS physical devices only.


## [2.3.19] - 2018-03-14

### Fixed
* Fixed device profile for `android_phone` - Generic Android Phone.


## [2.3.18] - 2018-03-11

### Changed
* Updated `SelectList.define_list_elements` method to accept value for `:list_trigger` element.
* Updated `SelectList.choose_option` to respect `:list_item` value and to click on `:list_trigger` element, if one is specified.
* Updated `PageSection` and `PageObject` UI element object declaration methods to no longer use `class_eval` pattern.
* Updated device profiles for iPhone 7 (iOS 10) with Chrome browser and iPad (iOS 10) with Chrome browser.

### Fixed
* Fixed `SelectList.choose_option` to also accept `:text`, `:value`, and `:index` option hashes across all types of select list objects.


## [2.3.17] - 2018-03-08

### Added
* Added `List.wait_until_item_count_is` and `List.wait_until_item_count_changes` methods.

### Changed
* `UIElement.wait_until_value_is` and `List.wait_until_item_count_is` methods now accept comparison hash.


## [2.3.16] - 2018-03-04

### Added
* Added `PageSection.double_click`, `PageObject.right_click`, and `PageObject.send_keys` methods.


## [2.3.15] - 2018-03-02

### Added
* Added `PageObject.wait_until_exists` and `PageObject.wait_until_gone` methods.

### Fixed
* Fixed bug in `UIElement.get_object_type` method that could result in a `NoMethodError obj not defined` error.
* Fixed bug in `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods that failed to enqueue errors when UI elements could not be found.


## [2.3.14] - 2018-02-28

### Changed
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser.


## [2.3.13] - 2018-02-09

### Added
* Added `AppiumServer.start`, `AppiumServer.running?`, and `AppiumServer.stop` methods for starting and stopping the Appium Server prior to executing tests on
iOS physical devices or simulators, or Android virtual device emulators.


## [2.3.12] - 2018-02-07

### Added
* Added `Environ.is_simulator?` and `Environ.is_web?` methods.


## [2.3.11] - 2018-02-02

### Added
* Added support for running tests in Mobile Safari browser on physical iOS devices.

### Changed
* Updated device profiles for iPhone 7 (iOS 10) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.3.10] - 2018-01-31

### Added
* Added support for running tests in mobile Chrome or Android browsers on Android Studio virtual device emulators.
* Added `displayed?`, `get_all_items_count`, and `get_all_list_items` methods to `PageSection` class.
* Added `get_all_items_count`, and `get_all_list_items` methods to `List` class.


## [2.3.9] - 2018-01-27

### Changed
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to accept optional `wait_time` parameter.
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser, iPhone 7 (iOS 10) with Chrome browser, and iPhone 7 (iOS 10) with Firefox browser.
* Updated device profiles for iPad (iOS 10) with Chrome browser and iPad (iOS 10) with Firefox browser.


## [2.3.8] - 2018-01-23

### Fixed
* Fixed locator resolution for **Indexed PageSection Objects**.


## [2.3.7] - 2018-01-18

### Added
* Added `width`, `height`, `x`, `y`, and `displayed?` methods to `UIElement` class.


## [2.3.6] - 2017-12-21

### Added
* Added `TextField.clear` method for deleting the contents of text fields. This method should trigger the `onchange` event for the associated text field.

### Changed
* `TextField.clear` method now works with most `number` type fields.


## [2.3.5] - 2017-12-19

### Changed
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to be compatible with Redactor editor fields.
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser, iPhone 7 (iOS 10) with Chrome browser, and iPhone 7 (iOS 10) with Firefox browser.


## [2.3.4] - 2017-12-12

### Fixed
* Fixed bug in `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods that prevented deletion of data in number type textfields
and textarea controls.


## [2.3.3] - 2017-12-09

### Added
* Added device profile for iPhone 7 (iOS 10) with MS Edge browser.

### Fixed
* Corrected device profiles for iPad (iOS 10) with Mobile Chrome browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.3.1] - 2017-12-07

### Added
* When testing using remotely hosted browsers on the BrowserStack service, the BrowserStack Local instance is automatically started if the `TUNNELING`
Environment Variable is set to `true`. `Environ.tunneling` will be set to true if the BrowserStack Local instance is succesfully started.
* Added `TestCentricity::WebDriverConnect.close_tunnel` method to close BrowserStack Local instance when Local testing is enabled. Refer to the
**Remotely hosted desktop and mobile web browsers** section for information on usage.


## [2.2.1] - 2017-11-29

### Changed
* `SelectList.choose_option` method now accepts index values for Chosen list objects.


## [2.2.0] - 2017-11-29

### Changed
* CSS selectors or XPath expressions may be used as locators for all types of **UI Elements**, including tables.


## [2.1.10] - 2017-11-14

### Added
* Added device profiles for iPhone 7 (iOS 10) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.1.9] - 2017-11-13

### Fixed
* Fixed bug in `SelectList.choose_option`, `SelectList.get_options`, `SelectList.get_option_count`, and `SelectList.get_selected_option` methods which
did not recognize grouped option in Chosen list objects.


## [2.1.8] - 2017-11-09

### Added
* Added `PageSection.verify_list_items` method for **Indexed PageSection Objects**.


## [2.1.7] - 2017-11-07

### Changed
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to use backspace characters to delete contents of a textfield
instead of using `clear`, which was preventing `onchange` JavaScript events from being triggered in some browsers.


## [2.1.6] - 2017-10-31

### Fixed
* Fixed bug in `TestCentricity::WebDriverConnect.set_webdriver_path` method that was failing to set the path to the appropriate **chromedriver** file for OS X
and Windows.


## [2.1.5] - 2017-10-28

### Added
* Added `get_min`, `get_max`, and `get_step` methods to `TextField` class.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `min`, `max`, and `step` attributes
for textfields.

### Fixed
* Fixed Chrome and Firefox support for setting browser language via the `LOCALE` Environment Variable. This capability now works for emulated mobile
browsers hosted in a local instance of Chrome or Firefox.


## [2.1.4] - 2017-10-24

### Added
* Added suppression of the Info Bar that displays "Chrome is being controlled by automated test software" on locally hosted instances of the Chrome browser.


## [2.1.3] - 2017-10-17

### Added
* Added support for "tiling" or cascading multiple browser windows when the `BROWSER_TILE` and `PARALLEL` Environment Variables are set to true. For each
concurrent parallel thread being executed, the position of each browser will be offset by 100 pixels right and 100 pixels down. For parallel test execution,
use the [parallel_tests gem](https://rubygems.org/gems/parallel_tests) to decrease overall test execution time.


## [2.1.2] - 2017-10-01

### Added
* Added device profiles for Microsoft Lumia 950, Blackberry Leap, Blackberry Passport, and Kindle Fire HD 10
* Added ability to set browser language support via the `LOCALE` Environment Variable for local instances of Chrome browsers


## [2.1.0] - 2017-09-23

### Added
* Added device profiles for iPhone 8, iPhone 8 Plus, iPhone X devices running iOS 11
* Added device profile for iPad Pro 10.5" with iOS 11

### Changed
* Updated iPhone 7 and iPhone 7 Plus profiles to iOS 10
* Updated Google Pixel and Google Pixel XL profiles to Android 8
* Added device profiles for iPhone 7 (iOS 10) with Mobile Chrome browser and iPad (iOS 10) with Mobile Chrome browser
* The `TestCentricity::WebDriverConnect.initialize_web_driver` method now sets the `Environ` object to the correct device connection states for local and
cloud hosted browsers.

### Fixed
* The `TestCentricity::WebDriverConnect.initialize_web_driver` method no longer calls `initialize_browser_size` when running tests against cloud hosted
mobile web browser, which was resulting in Appium throwing exceptions for unsupported method calls.
* The `TestCentricity::WebDriverConnect.set_webdriver_path` method now correctly sets the path for Chrome webDrivers when the `HOST_BROWSER` Environment
Variable is set to `chrome`. Tests against locally hosted emulated mobile web browser running on a local instance of Chrome will now work correctly.
