require 'test/unit'

module TestCentricity
  class AppUIElement
    include Test::Unit::Assertions

    attr_reader   :parent, :locator, :context, :type, :name

    def initialize(name, parent, locator, context)
      @name       = name
      @parent     = parent
      @locator    = locator
      @context    = context
      @type       = nil
    end

    def get_object_type
      @type
    end

    def get_locator
      @locator
    end

    def get_name
      @name
    end

    def click
      obj = element
      object_not_found_exception(obj)
      obj.click
    end

    def tap
      obj = element
      object_not_found_exception(obj)
      x = obj.location.x
      y = obj.location.y
      tap_action = Appium::TouchAction.new.tap(element: obj, x: x, y: y)
      tap_action.perform
    end

    def double_tap
      obj = element
      object_not_found_exception(obj)
      x = obj.location.x
      y = obj.location.y
      tap_action = Appium::TouchAction.new.double_tap(element: obj, x: x, y: y)
      tap_action.perform
    end

    def set(value)
      obj = element
      object_not_found_exception(obj)
      if value.is_a?(Array)
        obj.send_keys(value[0])
        obj.send_keys(value[1])
      elsif value.is_a?(String)
        obj.send_keys(value)
      end
    end

    def send_keys(value)
      obj = element
      object_not_found_exception(obj)
      obj.send_keys(value)
    end

    def clear
      obj = element
      object_not_found_exception(obj)
      obj.clear
    end

    def get_value
      obj = element
      object_not_found_exception(obj)
      if AppiumConnect.is_webview?
        case obj.tag_name.downcase
        when 'input', 'select', 'textarea'
          obj.value
        else
          obj.text
        end
      else
        obj.value
      end
    end

    def get_caption
      obj = element
      object_not_found_exception(obj)
      if AppiumConnect.is_webview?
        case obj.tag_name.downcase
        when 'input', 'select', 'textarea'
          obj.value
        else
          obj.text
        end
      else
        if obj.tag_name == 'XCUIElementTypeNavigationBar'
          obj.attribute('name')
        else
          obj.attribute('label')
        end
      end
    end

    def exists?
      begin
        element.displayed?
      rescue
        false
      end
    end

    def visible?
      if exists?
        element.displayed?
      else
        false
      end
    end

    def hidden?
      !visible?
    end

    def enabled?
      obj = element
      object_not_found_exception(obj)
      obj.enabled?
    end

    def disabled?
      !enabled?
    end

    def selected?
      obj = element
      object_not_found_exception(obj)
      obj.selected?
    end

    def tag_name
      obj = element
      object_not_found_exception(obj)
      obj.tag_name
    end

    def get_attribute(attrib)
      obj = element
      object_not_found_exception(obj)
      obj.attribute(attrib)
    end

    # Wait until the object exists, or until the specified wait time has expired. If the wait time is nil, then the wait
    # time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_exists(0.5)
    #
    def wait_until_exists(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless exists?
    end

    # Wait until the object no longer exists, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   logout_button.wait_until_gone(5)
    #
    def wait_until_gone(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if exists?
    end

    # Wait until the object is visible, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_visible(0.5)
    #
    def wait_until_visible(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue
      raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless visible?
    end

    # Wait until the object is hidden, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_hidden(10)
    #
    def wait_until_hidden(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue
      raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if visible?
    end

    # Wait until the object's value equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   card_authorized_label.wait_until_value_is(5, 'Card authorized')
    #
    def wait_until_value_is(value, seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value == value }
    rescue
      raise "Value of UI #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
    end

    # Wait until the object's value changes to a different value, or until the specified wait time has expired. If the
    # wait time is nil, then the wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   basket_grand_total_label.wait_until_value_changes(5)
    #
    def wait_until_value_changes(seconds = nil)
      value = get_value
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value != value }
    rescue
      raise "Value of UI #{object_ref_message} failed to change from '#{value}' after #{timeout} seconds" if get_value == value
    end

    def width
      obj = element
      object_not_found_exception(obj)
      obj.size.width
    end

    # Return height of object.
    #
    # @return [Integer]
    # @example
    #   button_height = my_button.height
    #
    def height
      obj = element
      object_not_found_exception(obj)
      obj.size.height
    end

    # Return x coordinate of object's location.
    #
    # @return [Integer]
    # @example
    #   button_x = my_button.x
    #
    def x_loc
      obj = element
      object_not_found_exception(obj)
      obj.location.x
    end

    # Return y coordinate of object's location.
    #
    # @return [Integer]
    # @example
    #   button_y = my_button.y
    #
    def y_loc
      obj = element
      object_not_found_exception(obj)
      obj.location.y
    end

    def scroll(direction)
      obj = element
      object_not_found_exception(obj)
      execute_script('mobile: scroll', direction: direction.to_s, element: obj)
    end

    def swipe(direction)
      execute_script('mobile: swipe', direction: direction.to_s)
    end


    private

    def element
      parent_section = @context == :section
      parent_section ? tries ||= 2 : tries ||= 1

      if parent_section && tries > 1
        parent_obj = nil
        locators = @parent.get_locator
        locators.each do |parent_locator|
          if parent_obj.nil?
            parent_obj = find_element(parent_locator.keys[0], parent_locator.values[0])
          else
            parent_obj = parent_obj.find_element(parent_locator.keys[0], parent_locator.values[0])
          end
        end
        puts "Found parent object '#{@parent.get_name}' - #{@parent.get_locator}" if ENV['DEBUG']
        obj = parent_obj.find_element(@locator.keys[0], @locator.values[0])
        puts "Found object '#{@name}' - #{@locator}" if ENV['DEBUG']
        obj
      else
        obj = find_element(@locator.keys[0], @locator.values[0])
        puts "Found object '#{@name}' - #{@locator}" if ENV['DEBUG']
        obj
      end
    rescue
      retry if (tries -= 1) > 0
      nil
    end

    def object_not_found_exception(obj)
      @type.nil? ? object_type = 'Object' : object_type = @type
      raise ObjectNotFoundError.new("#{object_type} named '#{@name}' (#{get_locator}) not found") unless obj
    end

    def object_ref_message
      "object '#{@name}' (#{get_locator})"
    end
  end
end
