class CheckoutAddressScreen < BaseAppScreen
  include SharedCheckoutAddressScreen

  trait(:page_name)    { 'Checkout - Address' }
  trait(:page_locator) { { accessibility_id: 'checkout address screen' } }
  trait(:page_url)     { 'checkout-address' }

  # Checkout Address screen UI elements
  textfields fullname_field:     { accessibility_id: 'Full Name* input field' },
             address1_field:     { accessibility_id: 'Address Line 1* input field' },
             address2_field:     { accessibility_id: 'Address Line 2 input field' },
             city_field:         { accessibility_id: 'City* input field' },
             state_region_field: { accessibility_id: 'State/Region input field' },
             zip_code_field:     { accessibility_id: 'Zip Code* input field' },
             country_field:      { accessibility_id: 'Country* input field' }
  button     :to_payment_button, { accessibility_id: 'To Payment button' }
end
