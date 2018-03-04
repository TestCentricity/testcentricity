require 'test/unit'

module TestCentricity
  class ScreenSection
    include Test::Unit::Assertions

    attr_reader   :context, :name
    attr_accessor :locator
    attr_accessor :parent
    attr_accessor :parent_list
    attr_accessor :list_index

    def initialize(name, parent, context)
      @name        = name
      @parent      = parent
      @context     = context
      @parent_list = nil
      @list_index  = nil
      @locator     = nil
    end

    def get_locator
      @locator = section_locator
      locators = []
      if @context == :section && !@parent.nil?
        locators.push(@parent.get_locator)
      end

      if @parent_list.nil?
        locators.push(@locator)
      else
        locators.push(@parent_list.get_locator)
        if @list_index.nil?
          locators.push(@locator)
        else
          list_key = @locator.keys[0]
          list_value = "#{@locator.values[0]}[#{@list_index}]"
          locators.push( { list_key => list_value } )
        end
      end
      locators
    end

    def set_list_index(list, index = 1)
      @parent_list = list unless list.nil?
      @list_index  = index
    end

    def get_item_count
      raise 'No parent list defined' if @parent_list.nil?
      @parent_list.get_item_count
    end

    def get_list_items
      items = []
      (1..get_item_count).each do |item|
        set_list_index(nil, item)
        items.push(get_value)
      end
      items
    end

    def get_object_type
      :section
    end

    def get_name
      @name
    end

    def set_parent(parent)
      @parent = parent
    end

    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    def self.element(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppUIElement.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.elements(element_hash)
      element_hash.each do |element_name, locator|
        element(element_name, locator)
      end
    end

    def self.button(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppButton.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.buttons(element_hash)
      element_hash.each do |element_name, locator|
        button(element_name, locator)
      end
    end

    def self.textfield(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppTextField.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.textfields(element_hash)
      element_hash.each do |element_name, locator|
        textfield(element_name, locator)
      end
    end

    def self.switch(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppSwitch.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.switches(element_hash)
      element_hash.each do |element_name, locator|
        switch(element_name, locator)
      end
    end

    def self.checkbox(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppCheckBox.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.checkboxes(element_hash)
      element_hash.each do |element_name, locator|
        checkbox(element_name, locator)
      end
    end

    def self.label(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppLabel.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.labels(element_hash)
      element_hash.each do |element_name, locator|
        label(element_name, locator)
      end
    end

    def self.list(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppList.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.lists(element_hash)
      element_hash.each do |element_name, locator|
        list(element_name, locator)
      end
    end

    def self.selectlist(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppSelectList.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.selectlists(element_hash)
      element_hash.each do |element_name, locator|
        selectlist(element_name, locator)
      end
    end

    def self.image(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppImage.new("#{element_name}", self, #{locator}, :section);end))
    end

    def self.images(element_hash)
      element_hash.each do |element_name, locator|
        image(element_name, locator)
      end
    end

    def self.alert(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppAlert.new("#{element_name}", self, #{locator}, :page);end))
    end

    def self.section(section_name, class_name)
      class_eval(%(def #{section_name};@#{section_name} ||= #{class_name}.new("#{section_name}", self, :section);end))
    end

    def self.sections(section_hash)
      section_hash.each do |section_name, class_name|
        section(section_name, class_name)
      end
    end


    def click
      section = find_section
      section_not_found_exception(section)
      section.click
    end

    def tap
      section = find_section
      section_not_found_exception(section)
      x = section.location.x
      y = section.location.y
      tap_action = Appium::TouchAction.new.tap(element: section, x: x, y: y)
      tap_action.perform
    end

    def double_tap
      section = find_section
      section_not_found_exception(section)
      x = section.location.x
      y = section.location.y
      tap_action = Appium::TouchAction.new.double_tap(element: section, x: x, y: y)
      tap_action.perform
    end

    def exists?
      section = find_section
      section != nil
    end

    def enabled?
      section = find_section
      section_not_found_exception(section)
      section.enabled?
    end

    def disabled?
      section = find_section
      section_not_found_exception(section)
      section.enabled?
    end

    def visible?
      if exists?
        section.displayed?
      else
        false
      end
    end

    def hidden?
      !visible?
    end

    def wait_until_exists(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless exists?
    end

    def wait_until_gone(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if exists?
    end

    def wait_until_visible(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue
      raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless visible?
    end

    def wait_until_hidden(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue
      raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if visible?
    end



    def width
      section = find_section
      section_not_found_exception(section)
      section.size.width
    end

    def height
      section = find_section
      section_not_found_exception(section)
      section.size.height
    end

    def x_loc
      section = find_section
      section_not_found_exception(section)
      section.location.x
    end
    def y_loc
      section = find_section
      section_not_found_exception(section)
      section.location.y
    end




    def verify_ui_states(ui_states)
      ui_states.each do |ui_object, object_states|
        object_states.each do |property, state|

          puts "#{ui_object.get_name} - #{property} = #{state}" if ENV['DEBUG']

          case property
          when :exists
            actual = ui_object.exists?
          when :enabled
            actual = ui_object.enabled?
          when :disabled
            actual = ui_object.disabled?
          when :visible
            actual = ui_object.visible?
          when :hidden
            actual = ui_object.hidden?
          when :checked
            actual = ui_object.checked?
          when :selected
            actual = ui_object.selected?
          when :value
            actual = ui_object.get_value
          when :caption
            actual = ui_object.get_caption
          when :name
            actual = ui_object.tag_name
          when :placeholder
            actual = ui_object.get_placeholder
          when :readonly
            actual = ui_object.read_only?
          when :maxlength
            actual = ui_object.get_max_length
          when :items
            actual = ui_object.get_list_items
          when :itemcount
            actual = ui_object.get_item_count
          when :width
            actual = ui_object.width
          when :height
            actual = ui_object.height
          when :x
            actual = ui_object.x_loc
          when :y
            actual = ui_object.y_loc
          end

          if state.is_a?(Hash) && state.length == 1
            error_msg = "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property to"
            state.each do |key, value|
              case key
              when :lt, :less_than
                ExceptionQueue.enqueue_exception("#{error_msg} be less than #{value} but found '#{actual}'") unless actual < value
              when :lt_eq, :less_than_or_equal
                ExceptionQueue.enqueue_exception("#{error_msg} be less than or equal to #{value} but found '#{actual}'") unless actual <= value
              when :gt, :greater_than
                ExceptionQueue.enqueue_exception("#{error_msg} be greater than #{value} but found '#{actual}'") unless actual > value
              when :gt_eq, :greater_than_or_equal
                ExceptionQueue.enqueue_exception("#{error_msg} be greater than or equal to  #{value} but found '#{actual}'") unless actual >= value
              when :starts_with
                ExceptionQueue.enqueue_exception("#{error_msg} start with '#{value}' but found '#{actual}'") unless actual.start_with?(value)
              when :ends_with
                ExceptionQueue.enqueue_exception("#{error_msg} end with '#{value}' but found '#{actual}'") unless actual.end_with?(value)
              when :contains
                ExceptionQueue.enqueue_exception("#{error_msg} contain '#{value}' but found '#{actual}'") unless actual.include?(value)
              when :not_contains, :does_not_contain
                ExceptionQueue.enqueue_exception("#{error_msg} not contain '#{value}' but found '#{actual}'") if actual.include?(value)
              when :not_equal
                ExceptionQueue.enqueue_exception("#{error_msg} not equal '#{value}' but found '#{actual}'") if actual == value
              when :like, :is_like
                actual_like = actual.delete("\n")
                actual_like = actual_like.delete("\r")
                actual_like = actual_like.delete("\t")
                actual_like = actual_like.delete(' ')
                actual_like = actual_like.downcase
                expected    = value.delete("\n")
                expected    = expected.delete("\r")
                expected    = expected.delete("\t")
                expected    = expected.delete(' ')
                expected    = expected.downcase
                ExceptionQueue.enqueue_exception("#{error_msg} be like '#{value}' but found '#{actual}'") unless actual_like.include?(expected)
              when :translate
                expected = I18n.t(value)
                ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) translated #{property} property")
              end
            end
          else
            ExceptionQueue.enqueue_assert_equal(state, actual, "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property")
          end
        end
      end
    rescue ObjectNotFoundError => e
      ExceptionQueue.enqueue_exception(e.message)
    ensure
      ExceptionQueue.post_exceptions
    end

    def populate_data_fields(data, wait_time = nil)
      timeout = wait_time.nil? ? 5 : wait_time
      data.each do |data_field, data_param|
        unless data_param.blank?
          # make sure the intended UI target element is visible before trying to set its value
          data_field.wait_until_visible(timeout)
          if data_param == '!DELETE'
            data_field.clear
          else
            case data_field.get_object_type
            when :checkbox
              data_field.set_checkbox_state(data_param.to_bool)
            when :textfield
              data_field.set("#{data_param}\t")
            end
          end
        end
      end
    end

    private

    def find_section
      obj = nil
      locators = get_locator
      locators.each do |loc|
        if obj.nil?
          obj = find_element(loc.keys[0], loc.values[0])
          puts "Found object #{loc}" if ENV['DEBUG']
        else
          obj = obj.find_element(loc.keys[0], loc.values[0])
          puts "Found object #{loc}" if ENV['DEBUG']
        end
      end
      obj
    rescue
      nil
    end

    def section_not_found_exception(obj)
      raise ObjectNotFoundError.new("Section object '#{get_name}' (#{get_locator}) not found") unless obj
    end
  end
end
