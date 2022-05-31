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
  PageManager.current_page = target_page
end


Then(/^I expect the (.*) (?:page|screen) to be correctly displayed$/) do |screen_name|
  # find and verify that the specified target page/screen is loaded
  target_page = PageManager.find_page(screen_name)
  target_page.verify_page_exists
  # verify that target page/screen is correctly displayed
  target_page.verify_page_ui
end


When(/^I enter user credentials with (.*)$/) do |creds|
  cred_data = user_data_source.find_user_creds(creds.gsub(/\s+/, '_').downcase)
  login_screen.login(cred_data.username, cred_data.password)
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


When(/^I (.*) the popup request modal$/) do |action|
  PageManager.current_page.modal_action(action)
end
