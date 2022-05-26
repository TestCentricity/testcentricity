class ResetAppStateModal < BaseIOSModal
  trait(:section_name) { 'Reset App State Modal' }

  # Reset App State Modal UI elements
  alert :alert_modal, { xpath: "//XCUIElementTypeAlert[@name='Reset App State']" }
end
