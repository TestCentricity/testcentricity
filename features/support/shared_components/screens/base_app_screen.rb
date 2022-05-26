module SharedBaseAppScreen
  include WorldData
  include WorldPages

  def nav_menu_action(action)
    case action.downcase.to_sym
    when :open
      invoke_nav_menu
    when :close
      nav_menu.close if nav_menu.visible?
    else
      raise "#{action} is not a valid selector"
    end
  end

  def navigate_to
    invoke_nav_menu
    navigator
  end

  def verify_nav_menu(state)
    case state.downcase.to_sym
    when :closed
      nav_menu.verify_closed
    when :displayed
      nav_menu.verify_ui
    else
      raise "#{action} is not a valid selector"
    end
  end
end
