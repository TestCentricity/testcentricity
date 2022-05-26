module SharedCheckoutAddressScreen
  def verify_page_ui
    super
    ui = {
      header_label        => { visible: true, caption: 'Checkout' },
      fullname_field      => { visible: true, enabled: true, placeholder: 'Rebecca Winter' },
      address1_field      => { visible: true, enabled: true, placeholder: 'Mandorley 112' },
      address2_field      => { visible: true, enabled: true, placeholder: 'Entrance 1' },
      city_field          => { visible: true, enabled: true, placeholder: 'Truro' },
      state_region_field  => { visible: true, enabled: true, placeholder: 'Cornwall' },
      zip_code_field      => { visible: true, enabled: true, placeholder: '89750' },
      country_field       => { visible: true, enabled: true, placeholder: 'United Kingdom' },
      to_payment_button   => { visible: true, enabled: true, caption: 'To Payment' }
    }
    verify_ui_states(ui)
  end
end
