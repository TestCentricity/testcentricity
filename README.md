# TestCentricity™

[![Gem Version](https://badge.fury.io/rb/testcentricity.svg)](https://badge.fury.io/rb/testcentricity)  [![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](http://opensource.org/licenses/BSD-3-Clause)
![Gem Downloads](https://img.shields.io/gem/dt/testcentricity) ![Maintained](https://img.shields.io/maintenance/yes/2022)


The TestCentricity™ core framework for native mobile iOS and Android apps and desktop/mobile web testing implements a Screen
and Page Object Model DSL for use with Cucumber (version 7.x or greater), Appium, Capybara, and Selenium-Webdriver (version 4.x). It also facilitates
the configuration of the appropriate Appium capabilities and driver required to establish a connection with locally hosted or
cloud hosted (using BrowserStack, Sauce Labs, or TestingBot services) iOS and Android real devices or simulators. For more
information on desktop/mobile web testing with this gem, refer to docs for the [TestCentricity™ Web gem](https://www.rubydoc.info/gems/testcentricity_web)

The TestCentricity™ gem supports automated testing of native iOS and Android apps running on the following mobile test targets:
* locally hosted iOS device simulators or physical iOS devices (using Appium and XCode on macOS)
* locally hosted Android devices or Android Studio virtual device emulators (using Appium and Android Studio on macOS)
* cloud hosted physical devices and simulators from the following service:
    * [Browserstack](https://www.browserstack.com/list-of-browsers-and-platforms/app_automate)
    * [Sauce Labs](https://saucelabs.com/platform/mobile-testing)
    * [TestingBot](https://testingbot.com/mobile/realdevicetesting)

The TestCentricity™ gem also incorporates all of the features and capabilities of the TestCentricity™ Web framework gem, which
supports running automated tests against the following web test targets:
* locally hosted desktop browsers (Chrome, Edge, Firefox, Safari, or IE)
* locally hosted "headless" Chrome, Firefox, or Edge browsers
* remote desktop and emulated mobile web browsers hosted on Selenium Grid 4 and Dockerized Selenium Grid 4 environments
* mobile Safari browsers on iOS device simulators or physical iOS devices (using Appium and XCode on macOS)
* mobile Chrome or Android browsers on Android Studio virtual device emulators (using Appium and Android Studio on macOS)
* cloud hosted desktop (Firefox, Chrome, Safari, IE, or Edge) or mobile (iOS Mobile Safari or Android) web browsers using the following service:
  * [Browserstack](https://www.browserstack.com/list-of-browsers-and-platforms?product=automate)
  * [Sauce Labs](https://saucelabs.com/open-source#automated-testing-platform)
  * [TestingBot](https://testingbot.com/features)
  * [LambdaTest](https://www.lambdatest.com/selenium-automation)
* web portals utilizing JavaScript front end application frameworks like Ember, React, Angular, and GWT
* web pages containing HTML5 Video and Audio objects


## What's New

A complete history of bug fixes and new features can be found in the {file:CHANGELOG.md CHANGELOG} file.

The RubyDocs for this gem can be found [here](https://www.rubydoc.info/gems/testcentricity/).


## Which gem should I use?

| Tested platforms                                 | TestCentricity | TestCentricity Web |
|--------------------------------------------------|----------------|--------------------|
| Native mobile apps only                          | Yes            | No                 |
| Hybrid apps with WebViews only                   | Yes            | No                 |
| Native mobile apps and desktop/mobile web        | Yes            | No                 |
| Hybrid apps with WebViews and desktop/mobile web | Yes            | No                 |
| Desktop/mobile web only                          | No             | Yes                |

The TestCentricity gem is designed to support testing of native and hybrid mobile apps and/or web interfaces via desktop and
mobile web browsers. The TestCentricity Web gem only supports testing of web interfaces via desktop and mobile web browsers.


## Installation

TestCentricity version 3.0 and above requires Ruby 2.7.5 or later. To install the TestCentricity gem, add this line to your automation
project's Gemfile:

    gem 'testcentricity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install testcentricity


## Setup
### Using Cucumber

If you are using Cucumber, you need to require the following in your `env.rb` file:

    require 'capybara/cucumber'
    require 'testcentricity'


### Using RSpec

If you are using RSpec instead, you need to require the following in your `spec_helper.rb` file:

    require 'capybara/rspec'
    require 'testcentricity'


## ScreenObjects

The **Screen Object Model** is a test automation pattern that aims to create an abstraction of your native mobile app's User
Interface that can be used in tests. The **Screen** Object Model in native mobile test automation is equivalent to the **Page**
Object Model in web interface test automation.

A **Screen Object** is an object that represents a single screen in your AUT (Application Under Test). **Screen Objects**
encapsulate the implementation details of a mobile app screen and expose an API that supports interaction with, and validation
of the UI elements on the screen.

**Screen Objects** makes it easier to maintain automated tests because changes to screen UI elements are updated in only one
location - in the `ScreenObject` class definition. By adopting a **Screen Object Model**, Cucumber feature files and step
definitions are no longer required to hold specific information about a screen's UI objects, thus minimizing maintenance
requirements. If any element on, or property of a screen changes (text field attributes, button captions, element states,
etc.), maintenance is performed in the `ScreenObject` class definition only, typically with no need to update the affected
feature file, scenarios, or step definitions.


### Defining a ScreenObject

Your `ScreenObject` class definitions should be contained within individual `.rb` files in the `features/support/<platform>/screens`
folder of your test automation project, where `<platform>` is typically `ios` or `android`. For each screen in your app, you will
typically have to define two `ScreenObjects` - one for iOS and the other for Android.

    my_automation_project
        ├── config
        ├── features
        │   ├── step_definitions
        │   ├── support
        │   │   ├── android
        |   |   |   └── screens
        │   │   ├── ios
        |   |   |   └── screens
        │   │   ├── env.rb
        │   │   └── hooks.rb
        ├── Gemfile
        └── README.md


You define a new `ScreenObject` as shown below:

    class LoginScreen < TestCentricity::ScreenObject
    end


    class ProductsScreen < TestCentricity::ScreenObject
    end


    class CheckoutAddressScreen < TestCentricity::ScreenObject
    end


### Adding Traits to your ScreenObject

Native app screens typically have names associated with them. Screens also typically have a unique object or attribute that, when
present, indicates that the screen's contents have fully loaded.

The `page_name` trait is registered with the `PageManager` object, which includes a `find_page` method that takes a page name as
a parameter and returns an instance of the associated `ScreenObject`. If you intend to use the `PageManager`, you must define a
`page_name` trait for each `ScreenObject` to be registered.

The `page_name` trait is usually a `String` value that represents the name of the screen that will be matched by the
`PageManager.findpage` method. `page_name` traits are case and white-space sensitive. For screens that may be referenced with
multiple names, the `page_name` trait may also be an `Array` of `String` values representing those screen names.

The `page_locator` trait specifies a locator for unique object that exists once the screen's contents have been fully rendered. The
`page_locator` trait is a locator strategy that uniquely identifies the object. The `ScreenObject.verify_page_exists` method
waits for the `page_locator` trait to exist, and raises an exception if the wait time exceeds the `default_max_wait_time`.

A `page_url` trait should be defined if a screen can be directly loaded using a deep link. Specifying a `page_url` trait is optional,
as not all screens can be directly accessed via a deep link.

You define your screen's **Traits** as shown below:

    class LoginScreen < TestCentricity::ScreenObject
      trait(:page_name)    { 'Login' }
      trait(:page_locator) { { accessibility_id: 'login screen' } }
      trait(:page_url)     { 'login' }
    end


    class ProductsScreen < TestCentricity::ScreenObject
      trait(:page_name)    { 'Products' }
      trait(:page_locator) { { accessibility_id: 'products screen' } }
      trait(:page_url)     { 'store-overview' }
    end


    class CheckoutAddressScreen < TestCentricity::ScreenObject
      trait(:page_name)    { 'Checkout - Address' }
      trait(:page_locator) { { accessibility_id: 'checkout address screen' } }
      trait(:page_url)     { 'checkout-address' }
    end


### Adding UI Elements to your ScreenObject

Native app screens are made up of UI elements like text fields, check boxes, switches, lists, buttons, etc. **UI Elements** are
added to your `ScreenObject` class definition as shown below:

    class LoginScreen < TestCentricity::ScreenObject
      trait(:page_name)    { 'Login' }
      trait(:page_locator) { { accessibility_id: 'login screen' } }
      trait(:page_url)     { 'login' }
      
      # Login screen UI elements
      labels     username_label: { accessibility_id: 'Username'},
                 password_label: { xpath: '(//XCUIElementTypeStaticText[@name="Password"])[1]'},
                 username_error: { accessibility_id: 'Username-error-message' },
                 password_error: { accessibility_id: 'Password-error-message' },
                 generic_error:  { accessibility_id: 'generic-error-message' }
      textfields username_field: { accessibility_id: 'Username input field' },
                 password_field: { accessibility_id: 'Password input field' }
      button     :login_button,  { accessibility_id: 'Login button' }
    end


    class CheckoutAddressScreen < TestCentricity::ScreenObject
      trait(:page_name)    { 'Checkout - Address' }
      trait(:page_locator) { { accessibility_id: 'checkout address screen' } }
      trait(:page_url)     { 'checkout-address' }
      
      # Checkout Address screen UI elements
      textfields fullname_field:     { accessibility_id: 'Full Name* input field' },
                 address1_field:     { accessibility_id: 'Address Line 1* input field' },
                 address2_field:     { accessibility_id: 'Address Line 2 input field' },
                 city_field:         { accessibility_id: 'City* input field' },
                 state_region_field: { accessibility_id: 'State/Region input field' },
                 zip_code_field:     { accessibility_id: 'Zip Code* input field' },
                 country_field:      { accessibility_id: 'Country* input field' }
      button     :to_payment_button, { accessibility_id: 'To Payment button' }
    end


### Adding Methods to your ScreenObject

It is good practice for your Cucumber step definitions to call high level methods in your your `ScreenObject` instead of
directly accessing and interacting with a screen object's UI elements. You can add high level methods to your `ScreenObject`
class definition for interacting with the UI to hide implementation details, as shown below:

    class LoginScreen < TestCentricity::ScreenObject
      trait(:page_name)    { 'Login' }
      trait(:page_locator) { { accessibility_id: 'login screen' } }
      trait(:page_url)     { 'login' }
      
      # Login screen UI elements
      labels     username_label: { accessibility_id: 'Username'},
                 password_label: { xpath: '(//XCUIElementTypeStaticText[@name="Password"])[1]'},
                 username_error: { accessibility_id: 'Username-error-message' },
                 password_error: { accessibility_id: 'Password-error-message' },
                 generic_error:  { accessibility_id: 'generic-error-message' }
      textfields username_field: { accessibility_id: 'Username input field' },
                 password_field: { accessibility_id: 'Password input field' }
      button     :login_button,  { accessibility_id: 'Login button' }

      def verify_page_ui
        super
        ui = {
          header_label   => { visible: true, caption: 'Login' },
          username_label => { visible: true, caption: 'Username' },
          username_field => { visible: true, enabled: true },
          password_label => { visible: true, caption: 'Password' },
          password_field => { visible: true, enabled: true },
          login_button   => { visible: true, enabled: true, caption: 'Login' }
        }
        verify_ui_states(ui)
      end
      
      def login(username, password)
        fields = {
          username_field => username,
          password_field => password
        }
        populate_data_fields(fields)
        login_button.tap
      end
      
      def verify_entry_error(reason)
        ui = case reason.gsub(/\s+/, '_').downcase.to_sym
             when :invalid_password, :invalid_user
               { generic_error => { visible: true, caption: 'Provided credentials do not match any user in this service.' } }
             when :locked_account
               { generic_error => { visible: true, caption: 'Sorry, this user has been locked out.' } }
             when :no_username
               { username_error => { visible: true, caption: 'Username is required' } }
             when :no_password
               { password_error => { visible: true, caption: 'Password is required' } }
             else
               raise "#{reason} is not a valid selector"
             end
        verify_ui_states(ui)
      end
    end



Once your `ScreenObject` has been instantiated, you can call your methods as shown below:

    login_screen.login('snicklefritz', 'Pa55w0rd')
    login_screen.verify_entry_error('invalid user')


## ScreenSections

A `ScreenSection` is a collection of **UI Elements** that may appear in multiple locations on a screen, or on multiple screens 
in an app. It is a collection of **UI Elements** that represent a conceptual area of functionality, like a navigation bar, a
search capability, or a menu. **UI Elements** and functional behavior are confined to the scope of a `ScreenSection` object.

A `ScreenSection` may contain other `ScreenSection` objects.


### Defining a ScreenSection

Your `ScreenSection` class definitions should be contained within individual `.rb` files in the `features/support/<platform>/sections`
folder of your test automation project, where `<platform>` is typically `ios` or `android`. For each screen section in your app,
you will typically have to define two `ScreenSections` - one for iOS and the other for Android.

    my_automation_project
        ├── config
        ├── features
        │   ├── step_definitions
        │   ├── support
        │   │   ├── android
        |   |   |   ├── screens
        |   |   |   └── sections
        │   │   ├── ios
        |   |   |   ├── screens
        |   |   |   └── sections
        │   │   ├── env.rb
        │   │   └── hooks.rb
        ├── Gemfile
        └── README.md


You define a new `ScreenSection` as shown below:

    class NavMenu < TestCentricity::ScreenSection
    end


### Adding Traits to a ScreenSection

A `ScreenSection` typically has a root node object that encapsulates a collection of `UIElements`. The `section_locator` trait
specifies the CSS or Xpath expression that uniquely identifies that root node object.

You define your section's **Traits** as shown below:

    class NavMenu < TestCentricity::ScreenSection
      trait(:section_name)    { 'Nav Menu' }
      trait(:section_locator) { { xpath: '//XCUIElementTypeScrollView' } }
    end


### Adding UI Elements to your ScreenSection

A `ScreenSection` is typically made up of UI elements like text fields, check boxes, switches, lists, buttons, etc. **UI Elements**
are added to your `ScreenSection` class definition as shown below:

    class NavMenu < TestCentricity::ScreenSection
      trait(:section_name)    { 'Nav Menu' }
      trait(:section_locator) { { xpath: '//XCUIElementTypeScrollView' } }

      # Nav Menu UI elements
      buttons close_button:        { accessibility_id: 'close menu' },
              webview_button:      { accessibility_id: 'menu item webview' },
              qr_code_button:      { accessibility_id: 'menu item qr code scanner' },
              geo_location_button: { accessibility_id: 'menu item geo location' },
              drawing_button:      { accessibility_id: 'menu item drawing' },
              report_a_bug_button: { accessibility_id: 'menu item report a bug' },
              about_button:        { accessibility_id: 'menu item about' },
              reset_app_button:    { accessibility_id: 'menu item reset app' },
              biometrics_button:   { accessibility_id: 'menu item biometrics' },
              log_in_button:       { accessibility_id: 'menu item log in' },
              log_out_button:      { accessibility_id: 'menu item log out' },
              api_calls_button:    { accessibility_id: 'menu item api calls' },
              sauce_video_button:  { accessibility_id: 'menu item sauce bot video' }
    end


### Adding Methods to your ScreenSection

You can add methods to your `ScreenSection` class definition, as shown below:

    class NavMenu < TestCentricity::ScreenSection
      trait(:section_name)    { 'Nav Menu' }
      trait(:section_locator) { { xpath: '//XCUIElementTypeScrollView' } }

      # Nav Menu UI elements
      buttons close_button:        { accessibility_id: 'close menu' },
              webview_button:      { accessibility_id: 'menu item webview' },
              qr_code_button:      { accessibility_id: 'menu item qr code scanner' },
              geo_location_button: { accessibility_id: 'menu item geo location' },
              drawing_button:      { accessibility_id: 'menu item drawing' },
              report_a_bug_button: { accessibility_id: 'menu item report a bug' },
              about_button:        { accessibility_id: 'menu item about' },
              reset_app_button:    { accessibility_id: 'menu item reset app' },
              biometrics_button:   { accessibility_id: 'menu item biometrics' },
              log_in_button:       { accessibility_id: 'menu item log in' },
              log_out_button:      { accessibility_id: 'menu item log out' },
              api_calls_button:    { accessibility_id: 'menu item api calls' },
              sauce_video_button:  { accessibility_id: 'menu item sauce bot video' }

      def verify_ui
        ui = {
          self                => { visible: true },
          close_button        => { visible: true, enabled: true },
          webview_button      => { visible: true, enabled: true, caption: 'Webview' },
          qr_code_button      => { visible: true, enabled: true, caption: 'QR Code Scanner' },
          geo_location_button => { visible: true, enabled: true, caption: 'Geo Location' },
          drawing_button      => { visible: true, enabled: true, caption: 'Drawing' },
          report_a_bug_button => { visible: true, enabled: true, caption: 'Report A Bug' },
          about_button        => { visible: true, enabled: true, caption: 'About' },
          reset_app_button    => { visible: true, enabled: true, caption: 'Reset App State' },
          biometrics_button   => { visible: true, enabled: true, caption: 'FaceID' },
          log_in_button       => { visible: true, enabled: true, caption: 'Log In' },
          log_out_button      => { visible: true, enabled: true, caption: 'Log Out' },
          api_calls_button    => { visible: true, enabled: true, caption: 'Api Calls' },
          sauce_video_button  => { visible: true, enabled: true, caption: 'Sauce Bot Video' }
        }
        verify_ui_states(ui)
      end

      def close
        close_button.click
        self.wait_until_hidden(3)
      end

      def verify_closed
        verify_ui_states(close_button => { visible: false })
      end
    end


### Adding ScreenSections to your ScreenObject

You add a `ScreenSection` to its associated `ScreenObject` as shown below:

    class BaseAppScreen < TestCentricity::ScreenObject
      # Base App screen UI elements
      label    :header_label, { accessibility_id: 'container header' }
      sections nav_bar:  NavBar,
               nav_menu: NavMenu
    end

Once your `ScreenObject` has been instantiated, you can call its `ScreenSection` methods as shown below:

    base_screen.nav_menu.verify_ui


## AppUIElements

Native app `ScreenObjects` and `ScreenSections` are typically made up of **UI Element** like text fields, switches, lists,
buttons, etc. **UI Elements** are declared and instantiated within the class definition of the `ScreenObject` or `ScreenSection`
in which they are contained. With TestCentricity, all native app screen UI elements are based on the `AppUIElement` class.


### Declaring and Instantiating AppUIElements

Single `AppUIElement` declarations have the following format:

    elementType :elementName, { locator_strategy, locator_identifier }

* The `elementName` is the unique name that you will use to refer to the UI element and is specified as a `Symbol`.
* The `locator_strategy` specifies the [selector strategy](https://appium.io/docs/en/commands/element/find-elements/index.html#selector-strategies) 
that Appium will use to find the `AppUIElement`. Valid selectors are `accessibility_id:`, `id:`, `name:`, `class:`, `xpath:`, 
`predicate:` (iOS only), `class_chain:` (iOS only), and `css:` (WebViews in hybrid apps only).
* The `locator_identifier` is the value or attribute that uniquely and unambiguously identifies the `AppUIElement`.

Multiple `AppUIElement` declarations for a collection of elements of the same type can be performed by passing a hash table
containing the names and locators of each individual element.

### Example AppUIElement Declarations

Supported `AppUIElement` elementTypes and their declarations have the following format:

*Single element declarations:*

    class SampleScreen < TestCentricity::ScreenObject
      button     :button_name, { locator_strategy, locator_identifier }
      textfield  :field_name, { locator_strategy, locator_identifier }
      checkbox   :checkbox_name, { locator_strategy, locator_identifier }
      label      :label_name, { locator_strategy, locator_identifier }
      selectlist :select_name, { locator_strategy, locator_identifier }
      list       :list_name, { locator_strategy, locator_identifier }
      image      :image_name, { locator_strategy, locator_identifier }
      switch     :switch_name, { locator_strategy, locator_identifier }
      element    :element_name, { locator_strategy, locator_identifier }
      alert      :alert_name, { locator_strategy, locator_identifier }
    end

*Multiple element declarations:*

    class SampleScreen < TestCentricity::ScreenObject
      buttons    button_1_name: { locator_strategy, locator_identifier },
                 button_2_name: { locator_strategy, locator_identifier },
                 button_X_name: { locator_strategy, locator_identifier }
      textfields field_1_name: { locator_strategy, locator_identifier },
                 field_2_name: { locator_strategy, locator_identifier },
                 field_X_name: { locator_strategy, locator_identifier }
      checkboxes check_1_name: { locator_strategy, locator_identifier },
                 check_2_name: { locator_strategy, locator_identifier },
                 check_X_name: { locator_strategy, locator_identifier }
      labels     label_1_name: { locator_strategy, locator_identifier },
                 label_X_name: { locator_strategy, locator_identifier }
      images     image_1_name: { locator_strategy, locator_identifier },
                 image_X_name: { locator_strategy, locator_identifier }
    end

Refer to the Class List documentation for the `ScreenObject` and `ScreenSection` classes for details on the class methods used
for declaring and instantiating `AppUIElements`. Examples of UI element declarations can be found in the ***Adding UI Elements
to your ScreenObject*** and ***Adding UI Elements to your ScreenSection*** sections above.


### AppUIElement Inherited Methods

With TestCentricity, all native app UI elements are based on the `AppUIElement` class, and inherit the following methods:

**Action methods:**

    element.click
    element.tap
    element.double_tap
    element.hover_at(x, y)
    element.scroll(direction)
    element.swipe(direction)

**Object state methods:**

    element.exists?
    element.visible?
    element.hidden?
    element.enabled?
    element.disabled?
    element.selected?
    element.tag_name
    element.width
    element.height
    element.x_loc
    element.y_loc
    element.get_attribute(attrib)

**Waiting methods:**

    element.wait_until_exists(seconds)
    element.wait_until_gone(seconds)
    element.wait_until_visible(seconds)
    element.wait_until_hidden(seconds)
    element.wait_until_value_is(value, seconds)
    element.wait_until_value_changes(seconds)


### Populating your ScreenObject or ScreenSection with data

A typical automated test may be required to perform the entry of test data by interacting with various `AppUIElements` on your
`ScreenObject` or `ScreenSection`. This data entry can be performed using the various object action methods (listed above) for
each `AppUIElement` that needs to be interacted with.

The `ScreenObject.populate_data_fields` and `ScreenSection.populate_data_fields` methods support the entry of test data into a
collection of `AppUIElements`. The `populate_data_fields` method accepts a hash containing key/hash pairs of `AppUIElements`
and their associated data to be entered. Data values must be in the form of a `String` for `textfield` controls. For `checkbox`
controls, data must either be a `Boolean` or a `String` that evaluates to a `Boolean` value (Yes, No, 1, 0, true, false).

The `populate_data_fields` method verifies that data attributes associated with each `AppUIElement` is not `nil` or `empty`
before attempting to enter data into the `AppUIElement`.

The optional `wait_time` parameter is used to specify the time (in seconds) to wait for each `AppUIElement` to become viable
for data entry (the `AppUIElement` must be visible and enabled) before entering the associated data value. This option is
useful in situations where entering data, or setting the state of a `AppUIElement` might cause other `AppUIElements` to become
visible or active. Specifying a wait_time value ensures that the subsequent `AppUIElements` will be ready to be interacted with
as states are changed. If the wait time is `nil`, then the wait time will be 5 seconds.

    def enter_data(user_data)
      fields = {
        first_name_field   => user_data.first_name,
        last_name_field    => user_data.last_name,
        email_field        => user_data.email,
        phone_number_field => user_data.phone_number
      }
      populate_data_fields(fields, wait_time = 2)
    end


### Verifying AppUIElements on your ScreenObject or ScreenSection

A typical automated test executes one or more interactions with the user interface, and then performs a validation to verify
whether the expected state of the UI has been achieved. This verification can be performed using the various object state methods
(listed above) for each `AppUIElement` that requires verification. Depending on the complexity and number of `AppUIElements` to
be verified, the code required to verify the presence of `AppUIElements` and their correct states can become cumbersome.

The `ScreenObject.verify_ui_states` and `ScreenSection.verify_ui_states` methods support the verification of multiple properties
of multiple UI elements on a `ScreenObject` or `ScreenSection`. The `verify_ui_states` method accepts a hash containing key/hash
pairs of UI elements and their properties or attributes to be verified.

     ui = {
       object1 => { property: state },
       object2 => { property: state, property: state },
       object3 => { property: state }
     }
     verify_ui_states(ui)

The `verify_ui_states` method queues up any exceptions that occur while verifying each object's properties until all `AppUIElements`
and their properties have been checked, and then posts any exceptions encountered upon completion. Posted exceptions include a
screenshot of the screen where expected results did not match actual results.

The `verify_ui_states` method supports the following property/state pairs:

**All Objects:**

    :exists            Boolean
    :enabled           Boolean
    :disabled          Boolean
    :visible           Boolean
    :hidden            Boolean
    :width             Integer
    :height            Integer
    :x                 Integer
    :y                 Integer
    :class             String
    :value or :caption String
    :attribute         Hash

**Text Fields:**

    :placeholder String
    :readonly    Boolean  (WebViews only)
    :maxlength   Integer  (WebViews only)

**Checkboxes:**

    :checked Boolean

#### Comparison States

The `verify_ui_states` method supports comparison states using property/comparison state pairs:

    object => { property: { comparison_state: value } }

Comparison States:

    :lt or :less_than                  Integer or String
    :lt_eq or :less_than_or_equal      Integer or String
    :gt or :greater_than               Integer or String
    :gt_eq or :greater_than_or_equal   Integer or String
    :starts_with                       String
    :ends_with                         String
    :contains                          String
    :not_contains or :does_not_contain Integer or String
    :not_equal                         Integer, String, or Boolean


#### I18n Translation Validation

The `verify_ui_states` method also supports I18n string translations using property/I18n key name pairs:

    object => { property: { translate_key: 'name of key in I18n compatible .yml file' } }

**I18n Translation Keys:**

    :translate            String
    :translate_upcase     String
    :translate_downcase   String
    :translate_capitalize String
    :translate_titlecase  String

The example below depicts the usage of the `verify_ui_states` method to verify that the captions for menu items are correctly
translated.

    def verify_menu
      ui = {
        account_settings_item => { visible: true, caption: { translate: 'Header.settings.account' } },
        help_item             => { visible: true, caption: { translate: 'Header.settings.help' } },
        feedback_item         => { visible: true, caption: { translate: 'Header.settings.feedback' } },
        legal_item            => { visible: true, caption: { translate: 'Header.settings.legal' } },
        institution_item      => { visible: true, caption: { translate: 'Header.settings.institution' } },
        configurations_item   => { visible: true, caption: { translate: 'Header.settings.configurations' } },
        contact_us_item       => { visible: true, caption: { translate: 'Header.settings.contact' } },
        downloads_item        => { visible: true, caption: { translate: 'Header.settings.downloads' } }
      }
      verify_ui_states(ui)
    end

Each supported language/locale combination has a corresponding `.yml` file. I18n `.yml` file naming convention uses
[ISO-639 language codes and ISO-3166 country codes](https://docs.oracle.com/cd/E13214_01/wli/docs92/xref/xqisocodes.html).
For example:

| Language (Country)    | File name |
|-----------------------|-----------|
| English               | en.yml    |
| English (Canada)      | en-CA.yml |
| French (Canada)       | fr-CA.yml |
| French                | fr.yml    |
| Spanish               | es.yml    |
| German                | de.yml    |
| Portuguese (Brazil)   | pt-BR.yml |
| Portuguese (Portugal) | pt-PT.yml |

I18n `.yml` files contain key/value pairs representing the name of a translated string (key) and the string value.

Baseline translation strings are stored in `.yml` files in the `config/locales/` folder.

    my_automation_project
        ├── config
        │   ├── locales
        │   │   ├── en.yml
        │   │   ├── es.yml
        │   │   ├── fr.yml
        │   │   ├── fr-CA.yml
        │   │   └── en-AU.yml
        │   ├── test_data
        │   └── cucumber.yml
        ├── features
        ├── Gemfile
        └── README.md


## Instantiating ScreenObjects and Utilizing the PageManager

Before you can call the methods in your `ScreenObjects` and `ScreenSections`, you must instantiate the `ScreenObjects` of your
native mobile application, as well as create instance variables which can be used when calling `ScreenObject` methods from
your step definitions or specs.

The `PageManager` class provides methods for supporting the instantiation and management of `ScreenObjects` and `PageObjects`.
In the code example below, the `page_objects` method contains a hash table of your `ScreenObject` instances and their associated
`ScreenObject` classes to be instantiated by `PageManager`:

    module WorldPages
      def page_objects
        {
          login_screen:            LoginScreen,
          registration_screen:     RegistrationScreen,
          search_results_screen:   SearchResultsScreen,
          products_grid_screen:    ProductsCollectionScreen,
          product_detail_screen:   ProductDetailScreen,
          shopping_basket_screen:  ShoppingBasketScreen,
          payment_method_screen:   PaymentMethodScreen,
          confirm_purchase_screen: PurchaseConfirmationScreen,
          my_account_screen:       MyAccountScreen,
          my_order_history_screen: MyOrderHistoryScreen
        }
      end
    end
    
    World(WorldPages)


The `WorldPages` module above should be defined in the `world_pages.rb` file in the `features/support` folder.

Include the code below in your `env.rb` file to ensure that your `ScreenObjects` are instantiated before your Cucumber scenarios
are executed:

    include WorldPages
    WorldPages.instantiate_page_objects

**NOTE:** If you intend to use the `PageManager`, you must define a `page_name` trait for each of the `ScreenObjects` to be registered.


### Instantiating ScreenObjects and PageObjects for a combined native iOS/Android app and web app

If your native mobile apps share feature parity with a responsive desktop/mobile web UI, you can define iOS and Android specific
`ScreenObjects` and the corresponding web specific `PageObjects`. If you use the `PLATFORM` Environment Variable to specify the target
test platform (`ios`, `android`, or `web`) at test run time, the following implementation of the `page_objects` method will ensure
instantiation of the correct `ScreenObjects` or `PageObjects` at run time:

    module WorldPages
      def page_objects
        case ENV['PLATFORM'].downcase.to_sym
        when :ios, :android
          native_app_screen_objects
        when :web
          web_page_objects
        end
      end
    end

    def native_app_screen_objects
        {
          login_screen:            LoginScreen,
          registration_screen:     RegistrationScreen,
          search_results_screen:   SearchResultsScreen,
          products_grid_screen:    ProductsCollectionScreen,
          product_detail_screen:   ProductDetailScreen,
          shopping_basket_screen:  ShoppingBasketScreen,
          payment_method_screen:   PaymentMethodScreen,
          confirm_purchase_screen: PurchaseConfirmationScreen,
          my_account_screen:       MyAccountScreen,
          my_order_history_screen: MyOrderHistoryScreen
        }
    end

    def web_page_objects
        {
          login_screen:            LoginPage,
          registration_screen:     RegistrationPage,
          search_results_screen:   SearchResultsPage,
          products_grid_screen:    ProductsCollectionPage,
          product_detail_screen:   ProductDetailPage,
          shopping_basket_screen:  ShoppingBasketPage,
          payment_method_screen:   PaymentMethodPage,
          confirm_purchase_screen: PurchaseConfirmationPage,
          my_account_screen:       MyAccountPage,
          my_order_history_screen: MyOrderHistoryPage
        }
    end

    World(WorldPages)


### Leveraging the PageManager in your Cucumber tests

Many Cucumber based automated tests suites include scenarios that verify that web pages are correctly loaded, displayed, or can be
navigated to by clicking associated links. One such Cucumber navigation scenario is displayed below:

    Scenario Outline:  Verify screen navigation features
      Given I am on the Products screen
      When I tap the <screen_name> navigation menu item
      Then I expect the <screen_name> screen to be correctly displayed

      Examples:
        |screen_name      |
        |Registration     |
        |Shopping Basket  |
        |My Account       |
        |My Order History |

In the above example, the step definitions associated with the 3 steps can be implemented using the `PageManager.find_page` method
to match the specified `screen_name` argument with the corresponding `ScreenObject` as shown below:

    include TestCentricity

    When(/^I (?:load|am on) the (.*) (?:page|screen)$/) do |screen_name|
      # find and load the specified target page/screen
      target_page = PageManager.find_page(screen_name)
      target_page.load_page
    end
    
    
    When(/^I (?:click|tap) the ([^\"]*) navigation menu item$/) do |screen_name|
      # find and navigate to the specified target page/screen
      target_page = PageManager.find_page(screen_name)
      target_page.navigate_to
    end
    
    
    Then(/^I expect the (.*) (?:page|screen) to be correctly displayed$/) do |screen_name|
      # find and verify that the specified target page/screen is loaded
      target_page = PageManager.find_page(screen_name)
      target_page.verify_page_exists
      # verify that target page/screen is correctly displayed
      target_page.verify_page_ui
    end



## Connecting to a Mobile Simulator or Device

The `AppiumConnect.initialize_appium` method configures the appropriate Appium capabilities required to establish a connection
with a locally or cloud hosted target iOS or Android simulator or real device.


### Starting and stopping Appium Server

The Appium server must be running prior to invoking Cucumber to run your features/scenarios on locally hosted mobile simulators
or physical device. To programmatically control the starting and stopping of Appium server with the execution of your automated
tests, place the code shown below into your `hooks.rb` file.

    BeforeAll do
      # start Appium Server if command line option was specified and target browser is mobile simulator or device
      if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium
       end
    end
    
    AfterAll do
      # terminate Appium Server if command line option was specified and target browser is mobile simulator or device
      if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium && $server.running?
        $server.stop
      end
    end


The `APPIUM_SERVER` environment variable must be set to `run` in order to programmatically start and stop Appium server. This can be
set by adding the following to your `cucumber.yml` file and including `-p run_appium` in your command line when starting your Cucumber
test suite(s):

    run_appium: APPIUM_SERVER=run


### Connecting to Locally Hosted iOS Simulators or Physical Devices

You can run your automated tests on locally hosted iOS simulators or physically connected devices using Appium and XCode on macOS. You
must install Appium, XCode, and the iOS version-specific device simulators for XCode. Information about Appium setup and configuration
requirements for testing on physically connected iOS devices can be found on [this page](https://github.com/appium/appium/blob/master/docs/en/drivers/ios-xcuitest-real-devices.md).
The Appium server must be running prior to invoking Cucumber to run your features/scenarios.

Once your test environment is properly configured, the following **Environment Variables** must be set as described in the table below.

| **Environment Variable**   | **Description**                                                                                                                                                       |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `WEB_BROWSER`              | Must be set to `appium`                                                                                                                                               |
| `APP_PLATFORM_NAME`        | Must be set to `iOS`                                                                                                                                                  |
| `AUTOMATION_ENGINE`        | Must be set to `XCUITest`                                                                                                                                             |
| `APP_VERSION`              | Must be set to `15.4`, `14.5`, or which ever iOS version you wish to run within the XCode Simulator                                                                   |
| `APP_DEVICE`               | Set to iOS device name supported by the iOS Simulator (`iPhone 13 Pro Max`, `iPad Pro (12.9-inch) (5th generation)`, etc.) or name of physically connected iOS device |
| `DEVICE_TYPE`              | Must be set to `phone` or `tablet`                                                                                                                                    |
| `APP_UDID`                 | UDID of physically connected iOS device (not used for simulators)                                                                                                     |
| `TEAM_ID`                  | unique 10-character Apple developer team identifier string (not used for simulators)                                                                                  |
| `TEAM_NAME`                | String representing a signing certificate (not used for simulators)                                                                                                   |
| `APP_NO_RESET`             | [Optional] Don't reset app state after each test. Set to `true` or `false`                                                                                            |
| `APP_FULL_RESET`           | [Optional] Perform a complete reset. Set to `true` or `false`                                                                                                         |
| `WDA_LOCAL_PORT`           | [Optional] Used to forward traffic from Mac host to real iOS devices over USB. Default value is same as port number used by WDA on device.                            |
| `LOCALE`                   | [Optional] Locale to set for the simulator.  e.g.  `fr_CA`                                                                                                            |
| `LANGUAGE`                 | [Optional] Language to set for the simulator.  e.g.  `fr`                                                                                                             |
| `ORIENTATION`              | [Optional] Set to `portrait` or `landscape` (only for iOS simulators)                                                                                                 |
| `NEW_COMMAND_TIMEOUT`      | [Optional] Time (in Seconds) that Appium will wait for a new command from the client                                                                                  |


Refer to **section 9.5 (Using Configuration Specific Profiles in cucumber.yml)** below.


### Connecting to Locally Hosted Android Simulators or Physical Devices

You can run your automated tests on emulated Android devices using Appium and Android Studio on macOS. You must install Android
Studio, the desired Android version-specific virtual device emulators, and Appium. Refer to [this page](http://appium.io/docs/en/drivers/android-uiautomator2/index.html)
for information on configuring Appium to work with the Android SDK. The Appium server must be running prior to invoking Cucumber
to run your features/scenarios.

Once your test environment is properly configured, the following **Environment Variables** must be set as described in the table below.

| **Environment Variable**  | **Description**                                                                                                                |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| `WEB_BROWSER`             | Must be set to `appium`                                                                                                        |
| `APP_PLATFORM_NAME`       | Must be set to `Android`                                                                                                       |
| `AUTOMATION_ENGINE`       | Must be set to `UiAutomator2`                                                                                                  |
| `APP_VERSION`             | Must be set to `12.0`, or which ever Android OS version you wish to run with the Android Virtual Device                        |
| `APP_DEVICE`              | Set to Android Virtual Device ID (`Pixel_2_XL_API_26`, `Nexus_6_API_23`, etc.) found in Advanced Settings of AVD Configuration |
| `DEVICE_TYPE`             | Must be set to `phone` or `tablet`                                                                                             |
| `APP_UDID`                | UDID of physically connected Android device (not used for simulators)                                                          |
| `ORIENTATION`             | [Optional] Set to `portrait` or `landscape`                                                                                    |
| `APP_NO_RESET`            | [Optional] Don't reset app state after each test. Set to `true` or `false`                                                     |
| `APP_FULL_RESET`          | [Optional] Perform a complete reset. Set to `true` or `false`                                                                  |
| `LOCALE`                  | [Optional] Locale to set for the simulator.  e.g.  `fr_CA`                                                                     |
| `LANGUAGE`                | [Optional] Language to set for the simulator.  e.g.  `fr`                                                                      |
| `NEW_COMMAND_TIMEOUT`     | [Optional] Time (in Seconds) that Appium will wait for a new command from the client                                           |


Refer to **section 9.5 (Using Configuration Specific Profiles in cucumber.yml)** below.


###  Connecting to Remote Cloud Hosted iOS and Android Simulators or Physical Devices

You can run your automated tests against remote cloud hosted iOS and Android simulators and real devices using the BrowserStack,
SauceLabs, or TestingBot services. Refer to **section 9.5 (Using Configuration Specific Profiles in cucumber.yml)** below.


#### Remote iOS and Android Physical Devices on the BrowserStack service

For remotely hosted iOS and Android simulators and real devices on the BrowserStack service, the following **Environment Variables**
must be set as described in the table below. Refer to the [Browserstack-specific capabilities chart page](https://www.browserstack.com/app-automate/capabilities?tag=w3c)
for information regarding the specific capabilities.

| **Environment Variable** | **Description**                                                                                                                     |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| `WEB_BROWSER`            | Must be set to `browserstack`                                                                                                       |
| `BS_USERNAME`            | Must be set to your BrowserStack account user name                                                                                  |
| `BS_AUTHKEY`             | Must be set to your BrowserStack account access key                                                                                 |
| `BS_OS`                  | Must be set to `ios` or `android`                                                                                                   |
| `BS_DEVICE`              | Refer to `deviceName` capability in chart                                                                                           |
| `BS_OS_VERSION`          | Set to the OS version specified in the `platformVersion` capability in the chart                                                    |
| `DEVICE_TYPE`            | Must be set to `phone` or `tablet`                                                                                                  |
| `ORIENTATION`            | [Optional] Set to `portrait` or `landscape`                                                                                         |
| `RECORD_VIDEO`           | [Optional] Enable screen video recording during test execution (`true` or `false`)                                                  |
| `TIME_ZONE`              | [Optional] Specify custom time zone. Refer to `browserstack.timezone` capability in chart                                           |
| `IP_GEOLOCATION`         | [Optional] Specify IP Geolocation. Refer to [IP Geolocation](https://www.browserstack.com/ip-geolocation) to select a country code. |
| `SCREENSHOTS`            | [Optional] Generate screenshots for debugging (`true` or `false`)                                                                   |
| `NETWORK_LOGS`           | [Optional] Capture network logs (`true` or `false`)                                                                                 |
| `APPIUM_LOGS`            | [Optional] Generate Appium logs (`true` or `false`)                                                                                 |


#### Remote iOS and Android Physical Devices and Simulators on the Sauce Labs service

For remotely hosted iOS and Android simulators and real devices on the Sauce Labs service, the following **Environment Variables**
must be set as described in the table below. Refer to the [Platform Configurator page](https://saucelabs.com/platform/platform-configurator)
to obtain information regarding the specific capabilities.

| **Environment Variable** | **Description**                                                                                                 |
|--------------------------|-----------------------------------------------------------------------------------------------------------------|
| `WEB_BROWSER`            | Must be set to `saucelabs`                                                                                      |
| `SL_USERNAME`            | Must be set to your Sauce Labs account user name or email address                                               |
| `SL_AUTHKEY`             | Must be set to your Sauce Labs account access key                                                               |
| `DATA_CENTER`            | Must be set to your Sauce Labs account Data Center assignment (`us-west-1`, `eu-central-1`, `apac-southeast-1`) |
| `SL_OS`                  | Must be set to `ios` or `android`                                                                               |
| `SL_DEVICE`              | Refer to `deviceName` capability in chart                                                                       |
| `SL_OS_VERSION`          | Refer to `platformVersion` capability in the Config Script section of the Platform Configurator page            |
| `DEVICE_TYPE`            | Must be set to `phone` or `tablet`                                                                              |
| `ORIENTATION`            | [Optional] Set to `portrait` or `landscape`                                                                     |
| `RECORD_VIDEO`           | [Optional] Enable screen video recording during test execution (`true` or `false`)                              |
| `SCREENSHOTS`            | [Optional] Generate screenshots for debugging (`true` or `false`)                                               |


#### Remote iOS and Android Physical Devices and Simulators on the TestingBot service

For remotely hosted iOS and Android simulators and real devices on the TestingBot service, the following **Environment Variables**
must be set as described in the table below. Refer to the [TestingBot List of Devices page](https://testingbot.com/support/devices)
for information regarding the specific capabilities.

| **Environment Variable** | **Description**                                   |
|--------------------------|---------------------------------------------------|
| `WEB_BROWSER`            | Must be set to `testingbot`                       |
| `TB_USERNAME`            | Must be set to your TestingBot account user name  |
| `TB_AUTHKEY`             | Must be set to your TestingBot account access key |
| `TB_OS`                  | Must be set to `ios` or `android`                 |
| `TB_DEVICE`              | Refer to `deviceName` capability in chart         |
| `TB_OS_VERSION`          | Refer to `version` capability in chart            |
| `DEVICE_TYPE`            | Must be set to `phone` or `tablet`                |
| `REAL_DEVICE`            | Must be set to `true` for real devices            |



### Using Configuration Specific Profiles in cucumber.yml

While you can set **Environment Variables** in the command line when invoking Cucumber, a preferred method of specifying and managing
target platforms is to create platform specific **Profiles** that set the appropriate **Environment Variables** for each target
platform in your `cucumber.yml` file.

Below is a list of Cucumber **Profiles** for supported locally and remotely hosted iOS and Android simulators and real devices (put
these in in your `cucumber.yml` file). Before you can use the BrowserStack, SauceLabs, TestingBot or LambdaTest services, you will
need to replace the *INSERT USER NAME HERE* and *INSERT PASSWORD HERE* placeholder text with your user account and authorization
code for the cloud service(s) that you intend to connect with.

    #==============
    # conditionally load Page and Screen Object implementations based on which target platform we're running on
    #==============
    
    ios:     PLATFORM=ios --tags @ios -r features/support/ios -e features/support/android
    android: PLATFORM=android --tags @android -r features/support/android -e features/support/ios
    web:     PLATFORM=web --tags @web -r features/support/web -e features/support/ios -e features/support/android
    
    
    #==============
    # profiles for mobile device screen orientation
    #==============
    
    landscape: ORIENTATION=landscape
    portrait:  ORIENTATION=portrait
    
    
    #==============
    # profile to start Appium Server prior to running mobile browser tests on iOS or Android simulators or physical devices
    #==============
    run_appium: APPIUM_SERVER=run
    
    
    #==============
    # profiles for native iOS apps hosted within XCode iOS simulators
    # NOTE: Requires installation of XCode, iOS version specific target simulators, and Appium
    #==============
    
    appium_ios: WEB_BROWSER=appium --profile ios AUTOMATION_ENGINE=XCUITest APP_PLATFORM_NAME="iOS" NEW_COMMAND_TIMEOUT="30" <%= mobile %>
    app_ios_14: --profile appium_ios APP_VERSION="14.5"
    app_ios_15: --profile appium_ios APP_VERSION="15.4"
    
    iphone_12PM_14_sim: --profile app_ios_14 DEVICE_TYPE=phone APP_DEVICE="iPhone 12 Pro Max"
    iphone_13PM_15_sim: --profile app_ios_15 DEVICE_TYPE=phone APP_DEVICE="iPhone 13 Pro Max"
    iphone_11_14_sim:   --profile app_ios_14 DEVICE_TYPE=phone APP_DEVICE="iPhone 11"
    ipad_pro_12_15_sim: --profile app_ios_15 DEVICE_TYPE=tablet APP_DEVICE="iPad Pro (12.9-inch) (5th generation)"
    
    
    #==============
    # profiles for native Android apps hosted within Android Studio Android Virtual Device emulators
    # NOTE: Requires installation of Android Studio, Android version specific virtual device simulators, and Appium
    #==============
    
    appium_android:    WEB_BROWSER=appium --profile android AUTOMATION_ENGINE=UiAutomator2 APP_PLATFORM_NAME="Android" <%= mobile %>
    app_android_12:    --profile appium_android APP_VERSION="12.0"
    pixel_5_api31_sim: --profile app_android_12 DEVICE_TYPE=phone APP_DEVICE="Pixel_5_API_31"
    
    
    #==============
    # profiles for remotely hosted devices on the BrowserStack service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with access
    #          to your version control system
    #==============
    
    browserstack: WEB_BROWSER=browserstack BS_USERNAME="<INSERT USER NAME HERE>" BS_AUTHKEY="<INSERT PASSWORD HERE>" TEST_CONTEXT="TestCentricity"
    
    # BrowserStack iOS real device native app profiles
    bs_ios:           --profile browserstack --profile ios BS_OS=ios <%= mobile %>
    bs_iphone:        --profile bs_ios DEVICE_TYPE=phone
    bs_iphone13PM_15: --profile bs_iphone BS_OS_VERSION="15" BS_DEVICE="iPhone 13 Pro Max"
    bs_iphone11_14:   --profile bs_iphone BS_OS_VERSION="14" BS_DEVICE="iPhone 11"
    
    # BrowserStack Android real device native app profiles
    bs_android: --profile browserstack --profile android BS_OS=android <%= mobile %>
    bs_pixel5:  --profile bs_android BS_DEVICE="Google Pixel 5" BS_OS_VERSION="12.0" DEVICE_TYPE=phone
    
    
    #==============
    # profiles for remotely hosted devices on the SauceLabs service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with access
    #          to your version control system
    #==============
    
    saucelabs: WEB_BROWSER=saucelabs SL_USERNAME="<INSERT USER NAME HERE>" SL_AUTHKEY="<INSERT PASSWORD HERE>" DATA_CENTER="us-west-1" AUTOMATE_PROJECT="TestCentricity - SauceLabs"
    
    # SauceLabs iOS real device native app profiles
    sl_ios:           --profile saucelabs --profile ios SL_OS=ios <%= mobile %>
    sl_iphone:        --profile sl_ios DEVICE_TYPE=phone
    sl_iphone13PM_15: --profile sl_iphone SL_DEVICE="iPhone 13 Pro Max Simulator" SL_OS_VERSION="15.4"
    
    # SauceLabs Android real device native app profiles
    sl_android: --profile saucelabs --profile android SL_OS=android <%= mobile %>
    sl_pixel5:  --profile sl_android SL_DEVICE="Google Pixel 5 GoogleAPI Emulator" SL_OS_VERSION="12.0" DEVICE_TYPE=phone
    
    
    #==============
    # profiles for remotely hosted devices on the TestingBot service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with access
    #          to your version control system
    #==============
    
    testingbot: WEB_BROWSER=testingbot TB_USERNAME="<INSERT USER NAME HERE>" TB_AUTHKEY="<INSERT PASSWORD HERE>" AUTOMATE_PROJECT="TestCentricity - TestingBot"
    
    # TestingBot iOS real device native app profiles
    tb_ios:               --profile testingbot --profile ios TB_OS=iOS <%= mobile %>
    tb_iphone:            --profile tb_ios DEVICE_TYPE=phone
    tb_iphone11_14_dev:   --profile tb_iphone TB_OS_VERSION="14.0" TB_DEVICE="iPhone 11" REAL_DEVICE=true
    tb_iphone11_14_sim:   --profile tb_iphone TB_OS_VERSION="14.2" TB_DEVICE="iPhone 11"
    tb_iphone13PM_15_sim: --profile tb_iphone TB_OS_VERSION="15.4" TB_DEVICE="iPhone 13 Pro Max"
    
    # TestingBot Android real device native app profiles
    tb_android:    --profile testingbot --profile android TB_OS=Android <%= mobile %>
    tb_pixel_dev:  --profile tb_android TB_DEVICE="Pixel" TB_OS_VERSION="9.0" DEVICE_TYPE=phone REAL_DEVICE=true
    tb_pixel6_sim: --profile tb_android TB_DEVICE="Pixel 6" TB_OS_VERSION="12.0" DEVICE_TYPE=phone


To specify a mobile simulator or real device target using a profile at runtime, you use the flag `--profile` or `-p` followed
by the profile name when invoking Cucumber in the command line. For instance, the following command specifies that Cucumber will
run tests against an iPad Pro (12.9-inch) (5th generation) with iOS version 15.4 in an XCode Simulator in portrait orientation:

    cucumber -p ipad_pro_12_15_sim -p portrait
    
    NOTE:  Appium must be running prior to executing this command

You can ensure that Appium Server is running by including `-p run_appium` in your command line:

    cucumber -p ipad_pro_12_15_sim -p portrait -p run_appium


The following command specifies that Cucumber will run tests against a cloud hosted iPhone 13 Pro Max running iOS 15.4 on the
BrowserStack service:

    cucumber -p bs_iphone13PM_15



## Recommended Project Organization and Structure

Below is an example of the project structure of a typical Cucumber based native mobile app test automation framework with a Screen
Object Model architecture. `ScreenObject` class definitions should be stored in the `/features/support/<platform>/screens`
folders, organized in functional area sub-folders as needed. Likewise, `ScreenSection` class definitions should be stored in
the `/features/support/<platform>/sections` folder, where `<platform>` is typically `ios` or `android`.

Common embedded WebViews for native and hybrid apps that are shared with both iOS and Android platforms should be stored in
the `/features/support/shared_webviews` folder.

    my_automation_project
        ├── config
        │   ├── locales
        │   ├── test_data
        │   └── cucumber.yml
        ├── features
        │   ├── step_definitions
        │   ├── support
        │   │   ├── android
        |   |   |   ├── screens
        |   |   |   └── sections
        │   │   ├── ios
        |   |   |   ├── screens
        |   |   |   └── sections
        │   │   ├── shared_webviews
        │   │   ├── env.rb
        │   │   ├── hooks.rb
        │   │   └── world_pages.rb
        ├── Gemfile
        └── README.md


 <img src="https://i.imgur.com/DdoDOxV.jpg" alt="TestCentricity Native Mobile App Framework Overview" title="TestCentricity Native Mobile App Framework Overview">


### Combined native iOS/Android app and web app project

If your native mobile apps share feature parity and a common user experience with a responsive web UI that is accessed via
desktop/mobile web browsers, you can effectively create one set of Cucumber feature files and scenarios that can be used
to test across all three platforms - iOS, Android, and web.

Below is an example of the project structure of a typical Cucumber based native mobile app and web UI test automation framework
with a Screen and Page Object Model architecture. `ScreenObject` class definitions should be stored in the `/features/support/<platform>/screens`
folders, organized in functional area sub-folders as needed. Likewise, `ScreenSection` class definitions should be stored in
the `/features/support/<platform>/sections` folder. `PageObject` class definitions should be stored in the `/features/support/web/pages`
folders, organized in functional area sub-folders as needed, while `PageSection` class definitions should be stored in the
the `/features/support/web/sections` folder.

    my_automation_project
        ├── config
        │   ├── locales
        │   ├── test_data
        │   └── cucumber.yml
        ├── features
        │   ├── step_definitions
        │   ├── support
        │   │   ├── android
        |   |   |   ├── screens
        |   |   |   └── sections
        │   │   ├── ios
        |   |   |   ├── screens
        |   |   |   └── sections
        │   │   ├── web
        |   |   |   ├── pages
        |   |   |   └── sections
        │   │   ├── env.rb
        │   │   ├── hooks.rb
        │   │   └── world_pages.rb
        ├── Gemfile
        └── README.md


 <img src="https://i.imgur.com/uzFhvu4.jpg" alt="TestCentricity Native Mobile App and Web Framework Overview" title="TestCentricity Native Mobile App and Web Framework Overview">


## Copyright and License

TestCentricity™ Framework is Copyright (c) 2014-2022, Tony Mrozinski.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software without
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
