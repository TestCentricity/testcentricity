include TestCentricity


Given(/^I have launched the SauceLabs My Demo app$/) do
  # activate the app
  AppiumConnect.launch_app
end


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


When(/^I enter user credentials with (.*)$/) do |reason|
  case reason.gsub(/\s+/, '_').downcase.to_sym
  when :valid_data
    username = 'bob@example.com'
    password = '10203040'
  when :invalid_user
    username = 'iggy.snicklefritz@example.com'
    password = '10203040'
  when :locked_account
    username = 'alice@example.com'
    password = '10203040'
  when :no_username
    password = '10203040'
  when :no_password
    username = 'bob@example.com'
  else
    raise "#{reason} is not a valid selector"
  end
  login_screen.login(username, password)
end


Then(/^I expect an error to be displayed due to (.*)$/) do |reason|
  PageManager.current_page.verify_entry_error(reason)
end


When(/^I (.*) the navigation menu$/) do |action|
  PageManager.current_page.nav_menu_action(action)
end


Then(/^I expect the navigation menu to be correctly displayed$/) do
  PageManager.current_page.verify_nav_menu(state = :displayed)
end


Then(/^I expect the navigation menu to be hidden$/) do
  PageManager.current_page.verify_nav_menu(state = :closed)
end
