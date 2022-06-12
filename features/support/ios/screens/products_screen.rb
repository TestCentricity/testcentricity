class ProductsScreen < BaseAppScreen
  trait(:page_name)    { 'Products' }
  trait(:page_locator) { { accessibility_id: 'products screen' } }
  trait(:page_url)     { 'store-overview' }

  # Products screen UI elements
  list    :product_grid, { xpath: '//XCUIElementTypeScrollView/XCUIElementTypeOther[1]' }
  section :product_grid_item, ProductGridItem

  def initialize
    super
    # define the list item element for the Product grid object
    list_elements = { list_item: { xpath: '//XCUIElementTypeOther[@name="store item"]' } }
    product_grid.define_list_elements(list_elements)
    # associate the Product Grid Item indexed section object with the Product grid object
    product_grid_item.set_list_index(product_grid)
  end

  def verify_page_ui
    super
    ui = {
      header_label => { visible: true, caption: 'Products' },
      product_grid => { visible: true, itemcount: 6 }
    }
    verify_ui_states(ui)
  end

  def choose_product_item(product_id)
    product_data_source.find_product(product_id)
    product_grid_item.set_list_index(product_grid, product_id)
    product_grid_item.click
  end
end
