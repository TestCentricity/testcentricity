class CheckoutPaymentScreen < BaseAppScreen
  include SharedCheckoutPaymentScreen

  trait(:page_name)    { 'Checkout - Payment' }
  trait(:page_locator) { { accessibility_id: 'checkout payment screen' } }
  trait(:page_url)     { 'checkout-payment' }

  # Checkout Payment screen UI elements
  textfields payee_name_field:     { xpath: '(//XCUIElementTypeTextField[@name="Full Name* input field"])[1]' },
             card_number_field:    { accessibility_id: 'Card Number* input field' },
             expiration_field:     { accessibility_id: 'Expiration Date* input field' },
             security_code_field:  { accessibility_id: 'Security Code* input field' },
             recipient_name_field: { xpath: '(//XCUIElementTypeTextField[@name="Full Name* input field"])[2]' },
             address1_field:       { accessibility_id: 'Address Line 1* input field' },
             address2_field:       { accessibility_id: 'Address Line 2 input field' },
             city_field:           { accessibility_id: 'City* input field' },
             state_region_field:   { accessibility_id: 'State/Region input field' },
             zip_code_field:       { accessibility_id: 'Zip Code* input field' },
             country_field:        { accessibility_id: 'Country* input field' }
  checkbox   :bill_address_check,  { xpath: '//XCUIElementTypeOther[contains(@name, "checkbox")]'}
  button     :review_order_button, { accessibility_id: 'Review Order button' }
end
