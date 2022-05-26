class ProductsScreen < BaseAppScreen
  trait(:page_name)    { 'Products' }
  trait(:page_locator) { { accessibility_id: 'products screen' } }
  trait(:page_url)     { 'store-overview' }

  def verify_page_ui
    super
    ui = {
      header_label => { visible: true, caption: 'Products' }
    }
    verify_ui_states(ui)
  end
end
