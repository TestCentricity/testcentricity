@mobile @ios @android @regression


Feature:  App screen deep links
  In order to ensure comprehensive support for native app deep links
  As a developer of the TestCentricity gem
  I expect to validate that app screens can be directly accessed with minimal UI interactions


  Background:
    Given I have launched the SauceLabs My Demo app


  Scenario Outline:  Verify screens can be directly accessed via deep links
    Given I am on the <start> screen
    When I load the <destination> screen
    Then I expect the <destination> screen to be correctly displayed

    Examples:
      |start    |destination        |
      |Products |About              |
      |Products |Login              |
      |Products |Webview            |
      |Products |QR Code Scanner    |
      |Products |Geo Location       |
      |Products |Checkout - Address |
      |Products |Checkout - Payment |
      |About    |Products           |


  Scenario Outline:  Verify Product Item screen can be directly accessed via deep links
    Given I am on the Products screen
    And I access the data for product id <product_id>
    When I load the Product Item screen
    Then I expect the Product Item screen to be correctly displayed

    Examples:
      |product_id |
      |1          |
      |5          |


  Scenario Outline:  Verify empty and populated Cart screen can be directly accessed via deep links
    Given I am on the Products screen
    And the shopping cart is <state>
    When I load the Cart screen
    Then I expect the Cart screen to be correctly displayed

    Examples:
      |state |
      |empty |
      |full  |
