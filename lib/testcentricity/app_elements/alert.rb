module TestCentricity
  class AppAlert < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :alert
    end

    def await(seconds)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
      true
    rescue
      false
    end

    def accept
      alert_accept
      wait_until_gone(5)
    end

    def dismiss
      alert_dismiss
      wait_until_gone(5)
    end
  end
end
