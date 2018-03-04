require 'capybara/cucumber'
require 'test/unit'
require 'capybara/poltergeist'

require 'testcentricity/world_extensions'
require 'testcentricity/exception_queue_helper'
require 'testcentricity/utility_helpers'
require 'testcentricity/version'
require 'testcentricity/browser_helper'

require 'testcentricity/web_core/drag_drop_helper'
require 'testcentricity/web_core/page_objects_helper'
require 'testcentricity/web_core/page_sections_helper'
require 'testcentricity/web_core/webdriver_helper'

require 'testcentricity/data_objects/data_objects_helper'
require 'testcentricity/data_objects/environment'
require 'testcentricity/data_objects/excel_helper'

require 'testcentricity/web_elements/ui_elements_helper'
require 'testcentricity/web_elements/siebel_open_ui_helper'
require 'testcentricity/web_elements/button'
require 'testcentricity/web_elements/checkbox'
require 'testcentricity/web_elements/file_field'
require 'testcentricity/web_elements/image'
require 'testcentricity/web_elements/label'
require 'testcentricity/web_elements/link'
require 'testcentricity/web_elements/radio'
require 'testcentricity/web_elements/select_list'
require 'testcentricity/web_elements/list'
require 'testcentricity/web_elements/table'
require 'testcentricity/web_elements/textfield'
require 'testcentricity/web_elements/cell_element'
require 'testcentricity/web_elements/cell_button'
require 'testcentricity/web_elements/cell_checkbox'
require 'testcentricity/web_elements/cell_radio'
require 'testcentricity/web_elements/cell_image'
require 'testcentricity/web_elements/list_element'
require 'testcentricity/web_elements/list_button'
require 'testcentricity/web_elements/list_checkbox'
require 'testcentricity/web_elements/list_radio'

require 'testcentricity/app_core/appium_server'
require 'testcentricity/app_core/appium_connect_helper'
require 'testcentricity/app_core/screen_objects_helper'
require 'testcentricity/app_core/screen_sections_helper'

require 'testcentricity/app_elements/app_element_helper'
require 'testcentricity/app_elements/button'
require 'testcentricity/app_elements/checkbox'
require 'testcentricity/app_elements/label'
require 'testcentricity/app_elements/switch'
require 'testcentricity/app_elements/textfield'
require 'testcentricity/app_elements/list'
require 'testcentricity/app_elements/image'
require 'testcentricity/app_elements/select_list'
require 'testcentricity/app_elements/alert'


module TestCentricity
  class PageManager
    attr_accessor :current_page

    @page_objects = {}

    def self.register_page_objects(pages)
      result = ''
      pages.each do |page_object, page_class|
        obj = page_class.new
        @page_objects[page_object] = obj unless @page_objects.has_key?(page_object)
        page_names = obj.page_name
        page_names = Array(page_names) if page_names.is_a? String
        page_names.each do |name|
          page_key = name.gsub(/\s+/, '').downcase.to_sym
          if page_key != page_object
            @page_objects[page_key] = obj unless @page_objects.has_key?(page_key)
          end
          result = "#{result}def #{page_object};@#{page_object} ||= TestCentricity::PageManager.find_page(:#{page_object});end;"
        end
      end
      result
    end

    # Have all PageObjects been registered?
    #
    # @return [Boolean] true if all PageObjects have been registered
    # @example
    #   TestCentricity::PageManager.loaded?
    #
    def self.loaded?
      !@page_objects.empty?
    end

    def self.find_page(page_name)
      (page_name.is_a? String) ? page_id = page_name.gsub(/\s+/, '').downcase.to_sym : page_id = page_name
      @page_objects[page_id]
    end

    # Get the currently active PageObject
    #
    # @return [PageObject]
    # @example
    #   active_page = TestCentricity::PageManager.current_page
    #
    def self.current_page
      @current_page
    end

    # Sets the currently active PageObject
    #
    # @param page [PageObject] Reference to the active PageObject
    # @example
    #   TestCentricity::PageManager.current_page = product_search_page
    #
    def self.current_page=(page)
      @current_page = page
    end
  end


  class DataManager
    @data_objects = {}

    def self.register_data_objects(data)
      result = ''
      data.each do |data_type, data_class|
        @data_objects[data_type] = data_class.new unless @data_objects.has_key?(data_type)
        result = "#{result}def #{data_type};@#{data_type} ||= TestCentricity::DataManager.find_data_object(:#{data_type});end;"
      end
      result
    end

    def self.find_data_object(data_object)
      @data_objects[data_object]
    end

    # Have all DataObjects been registered?
    #
    # @return [Boolean] true if all DataObjects have been registered
    # @example
    #   TestCentricity::DataManager.loaded?
    #
    def self.loaded?
      !@data_objects.empty?
    end
  end
end
