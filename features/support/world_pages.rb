module WorldPages

  #
  # The page_objects method returns a hash table of your web or native mobile app's page objects and associated page
  # classes to be instantiated by the TestCentricity PageManager.
  #
  # Web Page Object class definitions are contained in the features/support/web/pages folder.
  # iOS Screen Object class definitions are contained in the features/support/ios/screens folder.
  # Android Screen Object class definitions are contained in the features/support/android/screens folder.
  #
  def page_objects
    {
      base_app_screen:         BaseAppScreen,
      about_screen:            AboutScreen,
      login_screen:            LoginScreen,
      webview_screen:          WebViewScreen,
      web_page_screen:         WebPageViewerScreen,
      products_screen:         ProductsScreen,
      product_item_screen:     ProductItemScreen,
      cart_screen:             CartScreen,
      checkout_address_screen: CheckoutAddressScreen,
      checkout_payment_screen: CheckoutPaymentScreen,
      qr_code_scanner_screen:  QRCodeScannerScreen,
      geo_location_screen:     GeoLocationScreen,
      biometrics_screen:       BiometricsScreen,
      saucebot_video_screen:   SauceBotScreen
    }
  end
end


World(WorldPages)
