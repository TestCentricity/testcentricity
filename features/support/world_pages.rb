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
      products_screen:         ProductsScreen,
      checkout_address_screen: CheckoutAddressScreen,
      checkout_payment_screen: CheckoutPaymentScreen,
      saucebot_video_screen:   SauceBotScreen
    }
  end
end


World(WorldPages)
