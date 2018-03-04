module TestCentricity
  class AppCheckBox < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :checkbox
    end

    def checked?
      obj = element
      object_not_found_exception(obj)
      obj.attribute('checked') == 'true'
    end

    def check
      obj = element
      object_not_found_exception(obj)
      obj.click unless obj.attribute('checked') == 'true'
    end

    def uncheck
      obj = element
      object_not_found_exception(obj)
      obj.click if obj.attribute('checked') == 'true'
    end
  end
end
