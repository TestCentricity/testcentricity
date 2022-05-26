@mobile @ios @android @regression


Feature:  Login page
  In order to ensure comprehensive support for native app login features
  As a developer of the TestCentricity gem
  I expect users to access the app only with valid login credentials


  Background:
    Given I have launched the SauceLabs My Demo app


  Scenario:  Verify login with valid credentials
    Given I am on the Login screen
    When I enter user credentials with valid data
    Then I expect the Checkout - Address screen to be correctly displayed


  Scenario Outline:  Verify correct error states when using invalid credentials
    Given I am on the Login screen
    When I enter user credentials with <reason>
    Then I expect an error to be displayed due to <reason>

    Examples:
      |reason         |
      |no username    |
      |no password    |
      |locked account |
      |invalid user   |
