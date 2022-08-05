module SharedWebPageViewerScreen
  def verify_page_ui
    sleep(5)
    super if Environ.is_android?
    # switch to WebView context
    AppiumConnect.webview_context
    # verify Apple home page is loaded
    ui = {
      nav_bar => { visible: true },
      footer  => { visible: true }
    }
    verify_ui_states(ui)
    # return to native app context
    AppiumConnect.default_context
  end
end
