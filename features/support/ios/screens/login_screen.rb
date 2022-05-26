class LoginScreen < BaseAppScreen
  include SharedLoginScreen

  trait(:page_name)    { 'Login' }
  trait(:page_locator) { { accessibility_id: 'login screen' } }
  trait(:page_url)     { 'login' }
  trait(:navigator)    { nav_menu.open_log_in }

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
