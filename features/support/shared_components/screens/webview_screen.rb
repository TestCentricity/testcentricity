module SharedWebViewScreen
  def verify_page_ui
    super
    ui = {
      header_label      => { visible: true, caption: 'Webview' },
      url_label         => { visible: true, caption: 'URL' },
      url_field         => { visible: true, enabled: true, placeholder: 'https://www.website.com' },
      go_to_site_button => { visible: true, enabled: true, caption: 'Go To Site' }
    }
    verify_ui_states(ui)
  end
end
