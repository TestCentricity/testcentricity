class ProductsScreen < BaseAppScreen
  trait(:page_name)    { 'Products' }
  trait(:page_locator) { { accessibility_id: 'products screen' } }
  trait(:page_url)     { 'store-overview' }

  # Products screen UI elements
  list    :product_list, { xpath: '//android.widget.ScrollView' }
  section :product_list_item, ProductListItem

  def initialize
    super
    # define the list item element for the Product list object
    list_elements = { list_item: { xpath: '//android.view.ViewGroup[@content-desc="store item"]' } }
    product_list.define_list_elements(list_elements)
    # associate the Product List Item indexed section object with the Product list object
    product_list_item.set_list_index(product_list)
  end

  def verify_page_ui
    super
    ui = {
      header_label => { visible: true, caption: 'Products' },
      product_list => { visible: true, itemcount: 6 }
    }
    verify_ui_states(ui)
  end
end
