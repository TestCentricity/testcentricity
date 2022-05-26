require 'test/unit'

module TestCentricity
  class ScreenObject < BaseScreenSectionObject
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
      define_screen_element(element_name, TestCentricity::AppUIElement, locator)
    end

    def self.elements(element_hash)
      element_hash.each do |element_name, locator|
        element(element_name, locator)
      end
    end

    def self.button(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppButton, locator)
    end

    def self.buttons(element_hash)
      element_hash.each do |element_name, locator|
        button(element_name, locator)
      end
    end

    def self.textfield(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppTextField, locator)
    end

    def self.textfields(element_hash)
      element_hash.each do |element_name, locator|
        textfield(element_name, locator)
      end
    end

    def self.switch(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppSwitch, locator)
    end

    def self.switches(element_hash)
      element_hash.each do |element_name, locator|
        switch(element_name, locator)
      end
    end

    def self.checkbox(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppCheckBox, locator)
    end

    def self.checkboxes(element_hash)
      element_hash.each do |element_name, locator|
        checkbox(element_name, locator)
      end
    end

    def self.label(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppLabel, locator)
    end

    def self.labels(element_hash)
      element_hash.each do |element_name, locator|
        label(element_name, locator)
      end
    end

    def self.list(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppList, locator)
    end

    def self.lists(element_hash)
      element_hash.each do |element_name, locator|
        list(element_name, locator)
      end
    end

    def self.selectlist(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppSelectList, locator)
    end

    def self.selectlists(element_hash)
      element_hash.each do |element_name, locator|
        selectlist(element_name, locator)
      end
    end

    def self.image(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppImage, locator)
    end

    def self.images(element_hash)
      element_hash.each do |element_name, locator|
        image(element_name, locator)
      end
    end

    def self.alert(element_name, locator)
      define_screen_element(element_name, TestCentricity::AppAlert, locator)
    end

    def self.alerts(element_hash)
      element_hash.each do |element_name, locator|
        alert(element_name, locator)
      end
    end

    def self.section(section_name, obj, locator = 0)
      define_screen_element(section_name, obj, locator)
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

    def wait_until_exists(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      if post_exception
        raise "Screen object #{self.class.name} not found after #{timeout} seconds" unless exists?
      else
        exists?
      end
    end

    def wait_until_gone(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Environ.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      if post_exception
        raise "Screen object #{self.class.name} remained visible after #{timeout} seconds" if exists?
      else
        exists?
      end
    end

    def navigate_to; end

    def verify_page_ui; end

    def load_page
      if exists?
        verify_page_exists
        return
      end

      url = if page_url.include?("://")
              page_url
            elsif !Environ.current.deep_link_prefix.blank?
              link_url = "#{Environ.current.deep_link_prefix}://#{page_url}"
              if Environ.is_android?
                $driver.execute_script(
                  'mobile:deepLink',
                  {
                    url: link_url,
                    package: Environ.current.android_app_id
                  }
                )
                verify_page_exists
                return
              else
                link_url
              end
            end

      if Environ.is_ios? && Environ.is_device?
        # launch Safari browser on iOS real device
        $driver.execute_script('mobile: launchApp', { bundleId: 'com.apple.mobilesafari' })
        unless $driver.is_keyboard_shown
          begin
            # attempt to find and click URL button on iOS 15 Safari browser
            find_element(:accessibility_id, 'TabBarItemTitle').click
          rescue
            # fall back to URL button on iOS 14 Safari browser
            find_element(:xpath, '//XCUIElementTypeButton[@name="URL"]').click
          end
        end
        # enter deep-link URL
        wait_for_object(:xpath, '//XCUIElementTypeTextField[@name="URL"]', 5).send_keys("#{url}\uE007")
        # wait for and accept the popup modal
        wait_for_object(:xpath, '//XCUIElementTypeButton[@name="Open"]', 10).click
      else
        $driver.get(url)
      end
      verify_page_exists
    end

    private
    
    def self.define_screen_element(element_name, obj, locator)
      define_method(element_name) do
        ivar_name = "@#{element_name}"
        ivar = instance_variable_get(ivar_name)
        return ivar if ivar
        instance_variable_set(ivar_name, obj.new(element_name, self, locator, :page))
      end
    end

    def wait_for_object(find_method, locator, seconds)
      wait = Selenium::WebDriver::Wait.new(timeout: seconds)
      obj = nil
      wait.until do
        obj = find_element(find_method, locator)
        obj.displayed?
      end
      obj
    end
  end
end
