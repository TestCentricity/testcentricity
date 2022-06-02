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
      actions = Appium::TouchAction.new
      actions.tap(element: obj).perform
    end

    def double_tap
      obj = element
      object_not_found_exception(obj)
      actions = Appium::TouchAction.new
      actions.double_tap(element: obj).perform
    end

    def set(value)
      obj = element
      object_not_found_exception(obj)
      if value.is_a?(Array)
        obj.send_keys(value[0])
        if value[1].is_a?(Integer)
          press_keycode(value[1])
        else
          obj.send_keys(value[1])
        end
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

    alias value get_value

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
      elsif Environ.is_ios?
        case obj.tag_name
        when 'XCUIElementTypeNavigationBar'
          obj.attribute(:name)
        else
          obj.attribute(:label)
        end
      else
        caption = obj.text
        if caption.blank? && obj.attribute(:class) == 'android.view.ViewGroup'
          caption_obj = obj.find_element(:xpath, '//android.widget.TextView')
          caption = caption_obj.text
        end
        caption
      end
    end

    alias caption get_caption

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
    def wait_until_exists(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      if post_exception
        raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless exists?
      else
        exists?
      end
    end

    # Wait until the object no longer exists, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   logout_button.wait_until_gone(5)
    #
    def wait_until_gone(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      if post_exception
        raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if exists?
      else
        exists?
      end
    end

    # Wait until the object is visible, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_visible(0.5)
    #
    def wait_until_visible(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue
      if post_exception
        raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless visible?
      else
        visible?
      end
    end

    # Wait until the object is hidden, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_hidden(10)
    #
    def wait_until_hidden(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue
      if post_exception
        raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if visible?
      else
        hidden?
      end
    end

    # Wait until the object is enabled, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_enabled(10)
    #
    def wait_until_enabled(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { enabled? }
    rescue
      if post_exception
        raise "UI #{object_ref_message} remained disabled after #{timeout} seconds" unless enabled?
      else
        enabled?
      end
    end

    # Wait until the object's value equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Environ.default_max_wait_time.
    #
    # @param value [String or Hash] value expected or comparison hash
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   card_authorized_label.wait_until_value_is('Card authorized', 5)
    #     or
    #   total_weight_field.wait_until_value_is({ :greater_than => '250' }, 5)
    #
    def wait_until_value_is(value, seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { compare(value, get_value) }
    rescue
      if post_exception
        raise "Value of UI #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
      else
        get_value == value
      end
    end

    # Wait until the object's value changes to a different value, or until the specified wait time has expired. If the
    # wait time is nil, then the wait time will be Environ.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   basket_grand_total_label.wait_until_value_changes(5)
    #
    def wait_until_value_changes(seconds = nil, post_exception = true)
      value = get_value
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value != value }
    rescue
      if post_exception
        raise "Value of UI #{object_ref_message} failed to change from '#{value}' after #{timeout} seconds" if get_value == value
      else
        get_value == value
      end
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
      if Environ.is_ios?
        $driver.execute_script('mobile: scroll', direction: direction.to_s, element: obj)
      else
        case direction
        when :down
          x = obj.size.width.to_i / 2
          bottom = obj.size.height
          bottom = window_size[:height].to_i if bottom > window_size[:height]
          start_pt = [x, bottom]
          delta_pt = [0, 0 - (bottom - 20)]

        when :up
          x = obj.size.width.to_i / 2
          top = obj.location.y - (obj.size.height / 2)
          top = 0 if top < 0
          start_pt = [x, top]
          delta_pt = [0, obj.size.height / 2]
        end
        puts "Swipe start_pt = #{start_pt} / delta_pt = #{delta_pt}" if ENV['DEBUG']
        Appium::TouchAction.new.swipe(start_x: start_pt[0], start_y: start_pt[1], delta_x: delta_pt[0], delta_y: delta_pt[1]).perform
      end
    end

    def swipe(direction)
      obj = element
      object_not_found_exception(obj)
      if Environ.is_ios?
        $driver.execute_script('mobile: swipe', direction: direction.to_s, element: obj)
      else
        actions = Appium::TouchAction.new
        actions.scroll(element: obj).perform
      end
    end

    private

    def element
      if @context == :section
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
      puts "Did not find object '#{@name}' - #{@locator}" if ENV['DEBUG']
      nil
    end

    def object_not_found_exception(obj)
      @type.nil? ? object_type = 'Object' : object_type = @type
      raise ObjectNotFoundError.new("#{object_type} named '#{@name}' (#{get_locator}) not found") unless obj
    end

    def object_ref_message
      "object '#{@name}' (#{get_locator})"
    end

    def compare(expected, actual)
      if expected.is_a?(Hash)
        result = false
        expected.each do |key, value|
          case key
          when :lt, :less_than
            result = actual < value
          when :lt_eq, :less_than_or_equal
            result = actual <= value
          when :gt, :greater_than
            result = actual > value
          when :gt_eq, :greater_than_or_equal
            result = actual >= value
          when :not_equal
            result = actual != value
          end
        end
      else
        result = expected == actual
      end
      result
    end
  end
end
