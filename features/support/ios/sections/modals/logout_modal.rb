class LogOutModal < BaseIOSModal
  trait(:section_name) { 'Log Out Modal' }

  # Log Out Modal UI elements
  alert :alert_modal, { xpath: "//XCUIElementTypeAlert[@name='Log Out']" }
end
