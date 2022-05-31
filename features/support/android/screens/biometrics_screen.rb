class BiometricsScreen < BaseAppScreen
  trait(:page_name)    { 'Biometrics' }
  trait(:page_locator) { { accessibility_id: 'biometrics screen' } }
  trait(:navigator)    { nav_menu.open_biometrics }

  # Biometrics screen UI elements
  switch :fingerprint_switch, { accessibility_id: 'biometrics switch'}

  def verify_page_ui
    super
    ui = {
      header_label       => { visible: true, caption: 'FingerPrint' },
      fingerprint_switch => { visible: true, enabled: false }
    }
    verify_ui_states(ui)
  end
end
