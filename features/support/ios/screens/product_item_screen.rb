class ProductItemScreen < BaseAppScreen
  trait(:page_name)    { 'Product Item' }
  trait(:page_locator) { { accessibility_id: 'product screen' } }
  trait(:page_url)     { "product-details/#{ProductData.current.id.to_s}" }

  # Product Item screen UI elements
  labels  price_value:        { accessibility_id: 'product price' },
          description_value:  { accessibility_id: 'product description' },
          quantity_value:     { accessibility_id: 'counter amount' },
          highlights_label:   { accessibility_id: 'Product Highlights' }
  image   :product_image,     { xpath: '//XCUIElementTypeImage' }
  buttons add_to_cart_button: { accessibility_id: 'Add To Cart button' },
          minus_qty_button:   { accessibility_id: 'counter minus button' },
          plus_qty_button:    { accessibility_id: 'counter plus button' },
          black_color_button: { accessibility_id: 'black circle' },
          blue_color_button:  { accessibility_id: 'blue circle' },
          gray_color_button:  { accessibility_id: 'gray circle' },
          red_color_button:   { accessibility_id: 'red circle' }

  def verify_page_ui
    super
    ui = {
      header_label       => { visible: true, caption: ProductData.current.name },
      price_value        => { visible: true, caption: ProductData.current.price },
      highlights_label   => { visible: true, caption: 'Product Highlights' },
      description_value  => { visible: true, caption: ProductData.current.description },
      product_image      => { visible: true, enabled: true },
      black_color_button => { visible: ProductData.current.colors.include?('BLACK') },
      blue_color_button  => { visible: ProductData.current.colors.include?('BLUE') },
      gray_color_button  => { visible: ProductData.current.colors.include?('GRAY') },
      red_color_button   => { visible: ProductData.current.colors.include?('RED') },
      minus_qty_button   => { visible: true, enabled: true },
      quantity_value     => { visible: true, enabled: true, caption: '1' },
      plus_qty_button    => { visible: true, enabled: true },
      add_to_cart_button => { visible: true, enabled: true, caption: 'Add To Cart' }
    }
    verify_ui_states(ui)
  end
end
