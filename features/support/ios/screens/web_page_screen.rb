class WebPageViewerScreen < BaseAppScreen
  include SharedWebPageViewerScreen

  trait(:page_name)    { 'Web Page Viewer' }
  trait(:page_locator) { { accessibility_id: 'webview screen' } }

  # Apple Web Page UI elements
  elements nav_bar: { xpath: '//nav[@id="ac-globalnav"]' },
           footer:  { xpath: '//footer[@id="ac-globalfooter"]' }
end
