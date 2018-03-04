module TestCentricity
  class AppSwitch < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :switch
    end

    def on?
      obj = element
      object_not_found_exception(obj)
      obj.get_value == 1
    end

    def on
      obj = element
      object_not_found_exception(obj)
      obj.click unless obj.get_value == 1
    end

    def off
      obj = element
      object_not_found_exception(obj)
      obj.click if obj.get_value == 1
    end
  end
end
