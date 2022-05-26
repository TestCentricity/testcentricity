class BaseIOSModal < TestCentricity::ScreenSection
  trait(:section_name)    { 'Base iOS Modal' }
  trait(:section_locator) { { class: 'XCUIElementTypeAlert' } }

  # Base Modal UI elements
  alert :alert_modal, { class: 'XCUIElementTypeAlert' }

  def await_and_respond(action, timeout)
    if alert_modal.await(timeout)
      case action
      when :allow, :accept
        alert_modal.accept
      when :dont_allow, :dismiss
        alert_modal.dismiss
      else
        raise "#{action} is not a valid selector"
      end
      true
    else
      false
    end
  end
end
