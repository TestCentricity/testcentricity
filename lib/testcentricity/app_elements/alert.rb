module TestCentricity
  class AppAlert < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :alert
    end

    # Wait until the alert modal is visible, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Environ.default_max_wait_time. Unlike wait_until_visible or wait_until_exists, this method does not
    # raise an exception if the alert modal does not appear within the specified wait time.
    # Returns true if the alert modal is visible.
    #
    # @return [Integer]
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   permissions_modal.await(2)
    #
    def await(seconds)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
      true
    rescue
      false
    end

    # Performs the action required accept the currently visible alert modal. If the alert modal is still visible after
    # 5 seconds, an exception is raised.
    #
    # @example
    #   alert_modal.accept
    #
    def accept
      alert_accept
      wait_until_gone(5)
    end

    # Performs the action required dismiss the currently visible alert modal. If the alert modal is still visible after
    # 5 seconds, an exception is raised.
    #
    # @example
    #   alert_modal.dismiss
    #
    def dismiss
      alert_dismiss
      wait_until_gone(5)
    end

    #
    # @return [Integer]
    # @param action [Symbol] action to perform if alert modal is visible. Acceptable values are :allow, :accept, :dont_allow, or :dismiss
    # @param timeout [Integer or Float] wait time in seconds. Defaults to 2 if not specified
    # @param button_name [String] optional caption of button to tap associated with the specified action
    # @example
    #   alert_modal.await_and_respond(:dismiss)
    #        OR
    #   permissions_modal.await_and_respond(:accept, timeout = 1, button_name = 'Allow Once')
    #
    def await_and_respond(action, timeout = 2, button_name = nil)
      if await(timeout)
        case action
        when :allow, :accept
          if button_name.nil?
            accept
          elsif Environ.is_ios?
            $driver.execute_script('mobile: alert', { action: 'accept', buttonLabel: button_name })
          else
            $driver.execute_script('mobile: acceptAlert', { buttonLabel: button_name })
          end
        when :dont_allow, :dismiss
          if button_name.nil?
            dismiss
          elsif Environ.is_ios?
            $driver.execute_script('mobile: alert', { action: 'dismiss', buttonLabel: button_name })
          else
            $driver.execute_script('mobile: dismissAlert', { buttonLabel: button_name })
          end
        else
          raise "#{action} is not a valid selector"
        end
        if Environ.is_ios? && await(1)
          buttons = $driver.execute_script('mobile: alert', { action: 'getButtons' })
          raise "Could not perform #{action} action on active modal. Available modal buttons are #{buttons}"
        end
        true
      else
        false
      end
    end
  end
end
