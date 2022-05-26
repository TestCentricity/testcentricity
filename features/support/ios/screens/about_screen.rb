class AboutScreen < BaseAppScreen
  trait(:page_name)    { 'About' }
  trait(:page_locator) { { accessibility_id: 'about screen' } }
  trait(:page_url)     { 'about' }
  trait(:navigator)    { nav_menu.open_about }

  def verify_page_ui
    super
    verify_ui_states(header_label => { visible: true, caption: 'About' })
  end
end
