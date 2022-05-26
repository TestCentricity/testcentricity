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
      |Products |Checkout - Address |
      |Products |Checkout - Payment |
      |About    |Products           |
