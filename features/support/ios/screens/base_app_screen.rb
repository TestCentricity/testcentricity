class BaseAppScreen < TestCentricity::ScreenObject
  include SharedBaseAppScreen

  trait(:page_name) { 'Base App Screen' }

  # Base App screen UI elements
  label    :header_label, { accessibility_id: 'container header' }
  sections nav_bar:  NavBar,
           nav_menu: NavMenu

  def verify_page_ui
    nav_bar.verify_ui
  end

  def invoke_nav_menu
    nav_bar.open_menu
    nav_menu.wait_until_visible(3)
  end
end
