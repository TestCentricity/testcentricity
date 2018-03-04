module TestCentricity
  class AppList < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :list
    end

    def get_item_count
      obj = element
      object_not_found_exception(obj)
      if Environ.device_os == :ios
        items = obj.find_elements(:class, 'XCUIElementTypeCell')
      else
        items = obj.find_elements(:class, 'android.widget.FrameLayout')
      end
      items.size
    end

    def get_list_items

    end

    def get_list_item(index)

    end

    def wait_until_item_count_is(value, seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_item_count == value }
    rescue
      raise "Value of List #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_item_count == value
    end

    def wait_until_item_count_changes(seconds = nil)
      value = get_item_count
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_item_count != value }
    rescue
      raise "Value of List #{object_ref_message} failed to change from '#{value}' after #{timeout} seconds" if get_item_count == value
    end
  end
end
