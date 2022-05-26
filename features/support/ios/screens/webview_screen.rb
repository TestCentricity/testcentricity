class WebViewScreen < BaseAppScreen
  include SharedWebViewScreen

  trait(:page_name)    { 'Webview' }
  trait(:page_locator) { { accessibility_id: 'webview selection screen' } }
  trait(:page_url)     { 'webview' }
  trait(:navigator)    { nav_menu.open_webview }

  # Webview screen UI elements
  label     :url_label, { accessibility_id: 'URL' }
  textfield :url_field, { accessibility_id: 'URL input field' }
  button    :go_to_site_button, { accessibility_id: 'Go To Site button' }
end
