class QRCodeScannerScreen < BaseAppScreen
  trait(:page_name)    { 'QR Code Scanner' }
  trait(:page_locator) { { accessibility_id: 'qr code screen' } }
  trait(:page_url)     { 'qr-code-scanner' }
  trait(:navigator)    { nav_menu.open_qr_code_scanner }

  def verify_page_exists
    modal_action('accept')
    super
  end

  def verify_page_ui
    super
    verify_ui_states(header_label => { visible: true, caption: 'QR Code Scanner' })
  end

  def modal_action(action)
    grant_modal.await_and_respond(action.downcase.to_sym, timeout = 1, button_name = 'Only this time')
  end
end
