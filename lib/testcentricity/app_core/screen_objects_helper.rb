require 'test/unit'

module TestCentricity
  class BaseScreenSectionObject
    # Define a trait for this screen or section object.
    #
    # @param trait_name [Symbol] name of trait (as a symbol)
    # @param block [&block] trait value
    # @example
    #   trait(:page_name)        { 'Shopping Basket' }
    #   trait(:page_locator)     { { accessibility_id: 'My Contacts View' } }
    #   trait(:section_locator)  { { id: 'activity_feed_tabs' } }
    #
    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
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
              data_field.set(data_param)
            end
          end
        end
      end
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
          ExceptionQueue.enqueue_comparison(ui_object, state, actual, error_msg)
        end
      end
    rescue ObjectNotFoundError => e
      ExceptionQueue.enqueue_exception(e.message)
    ensure
      ExceptionQueue.post_exceptions
    end
  end
end
