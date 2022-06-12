module SharedCartScreen
  def define_deep_link
    CartData.current.nil? ? 'cart' : "cart/#{CartData.current.cart_items_deep_link}"
  end

  def verify_page_ui
    ui = if CartData.current.nil?
           {
             header_label => {
               visible: true,
               caption: 'No Items'
             },
             go_shopping_button => {
               visible: true,
               enabled: true,
               caption: 'Go Shopping',
             },
             empty_cart_image => { visible: true },
             total_label => { visible: false },
             total_qty_value => { visible: false },
             total_price_value =>{ visible: false },
             checkout_button => { visible: false }
           }
         else
           {
             header_label => {
               visible: true,
               caption: 'My Cart'
             },
             total_label => {
               visible: true,
               caption: 'Total:'
             },
             total_qty_value => {
               visible: true,
               caption: "#{CartData.current.total_quantity} items"
             },
             total_price_value => {
               visible: true,
               caption: CartData.current.total_price
             },
             checkout_button => {
               visible: true,
               enabled: true,
               caption: 'Proceed To Checkout',
             },
             cart_list => { visible: true, itemcount: CartData.current.num_items },
             go_shopping_button => { visible: false }
           }
         end
     verify_ui_states(ui)
    super
  end
end
