module TestCentricity
  class AppList < AppUIElement
    attr_accessor :list_item

    def initialize(name, parent, locator, context)
      super
      @type      = :list
      @list_item = nil
    end

    def define_list_elements(element_spec)
      element_spec.each do |element, value|
        case element
        when :list_item
          @list_item = value
        else
          raise "#{element} is not a recognized list element"
        end
      end
    end

    def get_item_count
      obj = element
      object_not_found_exception(obj)
      list_loc = get_list_item_locator
      items = obj.find_elements(list_loc.keys[0], list_loc.values[0])
      items.size
    end

    def get_list_items
      list_items = []
      obj = element
      object_not_found_exception(obj)
      list_loc = get_list_item_locator
      items = obj.find_elements(list_loc.keys[0], list_loc.values[0])
      items.each do |item|
        list_items.push(item.text)
      end
      list_items
    end

    def click_list_item(index)
      obj = element
      object_not_found_exception(obj)
      list_loc = get_list_item_locator
      items = obj.find_elements(list_loc.keys[0], list_loc.values[0])
      list_item = items[index]
      list_item.click
    end

    def get_list_item(index)

    end

    # Wait until the list's item_count equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Environ.default_max_wait_time.
    #
    # @param value [Integer or Hash] value expected or comparison hash
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   search_results_list.wait_until_item_count_is(10, 15)
    #     or
    #   search_results_list.wait_until_item_count_is({ :greater_than_or_equal => 1 }, 5)
    #
    def wait_until_item_count_is(value, seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { compare(value, get_item_count) }
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

    private

    def get_list_item_locator
      if @list_item.nil?
        if Environ.device_os == :ios
          define_list_elements({ :list_item => { class: 'XCUIElementTypeCell' } } )
        else
          define_list_elements({ :list_item => { class: 'android.widget.FrameLayout' } } )
        end
      end
      @list_item
    end
  end
end
