class QRCodeScannerScreen < BaseAppScreen
  trait(:page_name)    { 'QR Code Scanner' }
  trait(:page_locator) { { accessibility_id: 'qr code screen' } }
  trait(:page_url)     { 'qr-code-scanner' }
  trait(:navigator)    { nav_menu.open_qr_code_scanner }

  def verify_page_ui
    super
    verify_ui_states(header_label => { visible: true, caption: 'QR Code Scanner' })
  end
end
