@mobile @ios @android @regression


Feature:  Screen Navigation
  In order to ensure comprehensive support for native app navigation features
  As a developer of the TestCentricity gem
  I expect to validate that app screens can be accessed via navigation controls


  Background:
    Given I have launched the SauceLabs My Demo app
    And I am on the Products screen


  Scenario:  Verify navigation menu can be invoked and is properly displayed
    When I open the navigation menu
    Then I expect the navigation menu to be correctly displayed
    When I close the navigation menu
    Then I expect the navigation menu to be hidden


  Scenario Outline:  Verify screen navigation menu features
    When I tap the <screen_name> navigation menu item
    Then I expect the <screen_name> screen to be correctly displayed

    Examples:
      |screen_name    |
      |About          |
      |Login          |
      |Webview        |
      |SauceBot Video |


  Scenario Outline:  Verify screen navigation menu features with popup modals
    When I tap the <screen_name> navigation menu item
    And I accept the popup request modal
    Then I expect the <screen_name> screen to be correctly displayed

    Examples:
      |screen_name     |
      |QR Code Scanner |
      |Geo Location    |
      |Biometrics      |

@!ios
  Scenario Outline:  Verify Product Item screen is accessible via products grid selection
    When I choose product item <product_id> in the products grid
    Then I expect the Product Item screen to be correctly displayed

    Examples:
      |product_id |
      |2          |
      |1          |
