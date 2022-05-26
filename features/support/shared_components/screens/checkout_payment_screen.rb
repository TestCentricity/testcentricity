module SharedCheckoutPaymentScreen
  def verify_page_ui
    super
    ui = {
      header_label         => { visible: true, caption: 'Checkout' },
      payee_name_field     => { visible: true, enabled: true, placeholder: 'Rebecca Winter' },
      card_number_field    => { visible: true, enabled: true, placeholder: '3258 1265 7568 789' },
      expiration_field     => { visible: true, enabled: true, placeholder: '03/25' },
      security_code_field  => { visible: true, enabled: true, placeholder: '123' },
      bill_address_check   => { visible: true, enabled: true },
      recipient_name_field => { visible: false },
      address1_field       => { visible: false },
      address2_field       => { visible: false },
      city_field           => { visible: false },
      state_region_field   => { visible: false },
      zip_code_field       => { visible: false },
      country_field        => { visible: false },
      review_order_button  => { visible: true, enabled: true, caption: 'Review Order' }
    }
    verify_ui_states(ui)
  end
end
