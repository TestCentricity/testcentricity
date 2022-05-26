class NavBar < TestCentricity::ScreenSection
  trait(:section_name)    { 'Nav Bar' }
  trait(:section_locator) { { xpath: '(//XCUIElementTypeOther[@name="Catalog, tab, 1 of 3 0 Menu, tab, 3 of 3"])[1]' } }

  # Nav Bar UI elements
  buttons catalog_tab:    { accessibility_id: 'tab bar option catalog' },
          cart_tab:       { accessibility_id: 'tab bar option cart' },
          menu_tab:       { accessibility_id: 'tab bar option menu' }
  label   :cart_quantity, {}

  def verify_ui
    ui = {
      catalog_tab => { visible: true, enabled: true, caption: 'Catalog, tab, 1 of 3' },
      cart_tab    => { visible: true, enabled: true },
      menu_tab    => { visible: true, enabled: true, caption: 'Menu, tab, 3 of 3' }
    }
    verify_ui_states(ui)
  end

  def open_catalog
    catalog_tab.click
  end

  def open_cart
    cart_tab.click
  end

  def open_menu
    menu_tab.click
  end
end
