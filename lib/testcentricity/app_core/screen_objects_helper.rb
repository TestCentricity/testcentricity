require 'test/unit'

module TestCentricity
  class ScreenObject
    include Test::Unit::Assertions

    attr_reader :locator

    def initialize
      raise "Screen object #{self.class.name} does not have a page_name trait defined" unless defined?(page_name)
      @locator = page_locator if defined?(page_locator)
    end

    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    def self.element(element_name, locator)
      define_page_element(element_name, TestCentricity::AppUIElement, locator)
    end

    def self.elements(element_hash)
      element_hash.each do |element_name, locator|
        element(element_name, locator)
      end
    end

    def self.button(element_name, locator)
      define_page_element(element_name, TestCentricity::AppButton, locator)
    end

    def self.buttons(element_hash)
      element_hash.each do |element_name, locator|
        button(element_name, locator)
      end
    end

    def self.textfield(element_name, locator)
      define_page_element(element_name, TestCentricity::AppTextField, locator)
    end

    def self.textfields(element_hash)
      element_hash.each do |element_name, locator|
        textfield(element_name, locator)
      end
    end

    def self.switch(element_name, locator)
      define_page_element(element_name, TestCentricity::AppSwitch, locator)
    end

    def self.switches(element_hash)
      element_hash.each do |element_name, locator|
        switch(element_name, locator)
      end
    end

    def self.checkbox(element_name, locator)
      define_page_element(element_name, TestCentricity::AppCheckBox, locator)
    end

    def self.checkboxes(element_hash)
      element_hash.each do |element_name, locator|
        checkbox(element_name, locator)
      end
    end

    def self.label(element_name, locator)
      define_page_element(element_name, TestCentricity::AppLabel, locator)
    end

    def self.labels(element_hash)
      element_hash.each do |element_name, locator|
        label(element_name, locator)
      end
    end

    def self.list(element_name, locator)
      define_page_element(element_name, TestCentricity::AppList, locator)
    end

    def self.lists(element_hash)
      element_hash.each do |element_name, locator|
        list(element_name, locator)
      end
    end

    def self.selectlist(element_name, locator)
      define_page_element(element_name, TestCentricity::AppSelectList, locator)
    end

    def self.selectlists(element_hash)
      element_hash.each do |element_name, locator|
        selectlist(element_name, locator)
      end
    end

    def self.image(element_name, locator)
      define_page_element(element_name, TestCentricity::AppImage, locator)
    end

    def self.images(element_hash)
      element_hash.each do |element_name, locator|
        image(element_name, locator)
      end
    end

    def self.alert(element_name, locator)
      define_page_element(element_name, TestCentricity::AppAlert, locator)
    end

    def self.section(section_name, obj, locator = 0)
      define_page_element(section_name, obj, locator)
    end

    def self.sections(section_hash)
      section_hash.each do |section_name, class_name|
        section(section_name, class_name)
      end
    end


    def open_portal
      environment = Environ.current

      Environ.portal_state = :open
    end

    def verify_page_exists
      wait = Selenium::WebDriver::Wait.new(timeout: Environ.default_max_wait_time)
      wait.until { exists? }
      PageManager.current_page = self
    rescue
      raise "Could not find page_locator for screen object '#{self.class.name}' (#{@locator}) after #{Environ.default_max_wait_time} seconds"
    end

    def exists?
      @locator.is_a?(Array) ? tries ||= 2 : tries ||= 1
      if @locator.is_a?(Array)
        loc = @locator[tries - 1]
        find_element(loc.keys[0], loc.values[0])
      else
        find_element(@locator.keys[0], @locator.values[0])
      end
      true
    rescue
      retry if (tries -= 1) > 0
      false
    end

    def wait_until_exists(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Screen object #{self.class.name} not found after #{timeout} seconds" unless exists?
    end

    def wait_until_gone(seconds = nil)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      raise "Screen object #{self.class.name} remained visible after #{timeout} seconds" if exists?
    end

    def navigate_to; end

    def verify_page_ui; end

    def load_page
      navigate_to unless exists?
      verify_page_exists
      PageManager.current_page = self
    end



    def verify_ui_states(ui_states)
      ui_states.each do |ui_object, object_states|
        object_states.each do |property, state|

          puts "#{ui_object.get_name} - #{property} = #{state}" if ENV['DEBUG']

          case property
          when :class
            actual = ui_object.get_attribute(:class)
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
          error_msg = "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property to"
          ExceptionQueue.enqueue_comparison(state, actual, error_msg)
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
              data_field.clear
              data_field.set("#{data_param}\t")
            end
          end
        end
      end
    end

    private
    
    def self.define_page_element(element_name, obj, locator)
      define_method(element_name) do
        ivar_name = "@#{element_name}"
        ivar = instance_variable_get(ivar_name)
        return ivar if ivar
        instance_variable_set(ivar_name, obj.new(element_name, self, locator, :page))
      end
    end
  end
end
