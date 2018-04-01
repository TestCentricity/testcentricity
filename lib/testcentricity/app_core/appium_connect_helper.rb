require 'appium_lib'


module TestCentricity
  module AppiumConnect

    attr_accessor :running
    attr_accessor :config_file

    def self.initialize_appium(project_path = nil)
      Environ.platform    = :mobile
      Environ.driver      = :appium
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']
      Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']

      @config_file = project_path

      if project_path.nil?
        browser = ENV['WEB_BROWSER']
        Environ.browser = browser
        case browser.downcase.to_sym
        when :appium
          Environ.device_name = ENV['APP_DEVICE']
          Environ.device_os   = ENV['APP_PLATFORM_NAME']
          ENV['UDID'] ? Environ.device = :device : Environ.device = :simulator
        when :browserstack
          Environ.device_name = ENV['BS_DEVICE']
          Environ.device_os   = ENV['BS_OS']
        end
      end
      @running = false
    end

    def self.start_driver
      if @config_file.nil?
        browser = ENV['WEB_BROWSER']
        case browser.downcase.to_sym
        when :appium
          desired_capabilities = appium_local_capabilities
        when :browserstack
          desired_capabilities = browserstack_capabilities
        end
      else
        base_path = 'config'
        unless File.directory?(File.join(@config_file, base_path))
          raise 'Could not find appium.txt files in /config folder'
        end
        appium_caps = File.join(@config_file, base_path, 'appium.txt')
        desired_capabilities = Appium.load_appium_txt file: appium_caps
      end

      puts "Appium desired_capabilities = #{desired_capabilities}" if ENV['DEBUG']

      Appium::Driver.new(desired_capabilities).start_driver
      @running = true
      Appium.promote_appium_methods TestCentricity::ScreenObject
      Appium.promote_appium_methods TestCentricity::ScreenSection
      Appium.promote_appium_methods TestCentricity::AppUIElement

      Environ.screen_size = $driver.window_size
    end

    def self.quit_driver
      if @running
        $driver.driver_quit
        @running = false
      end
    end

    def self.driver
      $driver
    end

    def self.take_screenshot(png_save_path)
      FileUtils.mkdir_p(File.dirname(png_save_path))
      $driver.driver.save_screenshot(png_save_path)
    end

    def self.install_app(app_path)
      $driver.install_app(app_path)
    end

    def self.app_installed?(bundle_id)
      $driver.app_installed?(bundle_id)
    end

    def self.launch_app
      $driver.launch_app
    end

    def self.close_app
      $driver.close_app
    end

    def self.reset_app
      $driver.reset
    end

    def self.remove_app(bundle_id)
      $driver.remove_app(bundle_id)
    end

    def self.implicit_wait(timeout)
      $driver.manage.timeouts.implicit_wait = timeout
    end

    def self.hide_keyboard
      $driver.hide_keyboard
    end

    def self.keyboard_shown?
      $driver.is_keyboard_shown
    end

    def self.set_orientation(orientation)
      $driver.rotation = orientation.downcase.to_sym
    end

    def self.set_geolocation(latitude, longitude, altitude)
      $driver.set_location(latitude, longitude, altitude)
    end

    def self.current_context
      $driver.current_context
    end

    def self.set_context(context)
      $driver.set_context(context)
    end

    def self.available_contexts
      $driver.available_contexts
    end

    def self.default_context
      $driver.switch_to_default_context
      puts "Current context = #{$driver.current_context}" if ENV['DEBUG']
    end

    def self.is_webview?
      $driver.current_context.start_with?('WEBVIEW')
    end

    def self.is_native_app?
      $driver.current_context.start_with?('NATIVE_APP')
    end

    def self.webview_context
      contexts = available_contexts
      puts "Contexts = #{contexts}" if ENV['DEBUG']
      set_context(contexts.last)
      puts "Current context = #{$driver.current_context}" if ENV['DEBUG']
    end

    private

    def self.appium_local_capabilities
      desired_capabilities = {
          caps: {
              platformName:    ENV['APP_PLATFORM_NAME'],
              platformVersion: ENV['APP_VERSION'],
              deviceName:      ENV['APP_DEVICE'],
              automationName:  ENV['AUTOMATION_ENGINE']
          }
      }
      capabilities = desired_capabilities[:caps]
      capabilities[:avd]                    = ENV['APP_DEVICE'] if ENV['APP_PLATFORM_NAME'].downcase.to_sym == :android
      capabilities[:orientation]            = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
      capabilities[:language]               = ENV['LANGUAGE'] if ENV['LANGUAGE']
      capabilities[:locale]                 = ENV['LOCALE'].gsub('-', '_') if ENV['LOCALE']
      capabilities[:newCommandTimeout]      = ENV['NEW_COMMAND_TIMEOUT'] if ENV['NEW_COMMAND_TIMEOUT']
      capabilities[:noReset]                = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
      capabilities[:fullReset]              = ENV['APP_FULL_RESET'] if ENV['APP_FULL_RESET']
      capabilities[:webkitDebugProxyPort]   = ENV['WEBKIT_DEBUG_PROXY_PORT'] if ENV['WEBKIT_DEBUG_PROXY_PORT']
      capabilities[:webDriverAgentUrl]      = ENV['WEBDRIVER_AGENT_URL'] if ENV['WEBDRIVER_AGENT_URL']
      capabilities[:wdaLocalPort]           = ENV['WDA_LOCAL_PORT'] if ENV['WDA_LOCAL_PORT']
      capabilities[:usePrebuiltWDA]         = ENV['USE_PREBUILT_WDA'] if ENV['USE_PREBUILT_WDA']
      capabilities[:useNewWDA]              = ENV['USE_NEW_WDA'] if ENV['USE_NEW_WDA']
      capabilities[:startIWDP]              = ENV['START_IWDP'] if ENV['START_IWDP']
      capabilities[:autoWebview]            = ENV['AUTO_WEBVIEW'] if ENV['AUTO_WEBVIEW']
      capabilities[:chromedriverExecutable] = ENV['CHROMEDRIVER_EXECUTABLE'] if ENV['CHROMEDRIVER_EXECUTABLE']
      capabilities[:autoWebviewTimeout]     = ENV['AUTO_WEBVIEW_TIMEOUT'] if ENV['AUTO_WEBVIEW_TIMEOUT']

      if ENV['UDID']
        capabilities[:udid]           = ENV['UDID']
        capabilities[:bundleId]       = ENV['BUNDLE_ID'] if ENV['BUNDLE_ID']
        capabilities[:xcodeOrgId]     = ENV['TEAM_ID'] if ENV['TEAM_ID']
        capabilities[:xcodeSigningId] = ENV['TEAM_NAME'] if ENV['TEAM_NAME']
        capabilities[:appActivity]    = ENV['APP_ACTIVITY'] if ENV['APP_ACTIVITY']
        capabilities[:appPackage]     = ENV['APP_PACKAGE'] if ENV['APP_PACKAGE']
      end

      if ENV['APP']
        capabilities[:app] = ENV['APP']
      else
        if Environ.is_android?
          capabilities[:app] = Environ.current.android_apk_path
        elsif Environ.is_ios?
          Environ.is_device? ?
              capabilities[:app] = Environ.current.ios_ipa_path :
              capabilities[:app] = Environ.current.ios_app_path
        end
      end
      desired_capabilities
    end

    def self.browserstack_capabilities
      endpoint = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub"

      capabilities = {}
      capabilities['device']     = ENV['BS_DEVICE']
      capabilities['os_version'] = ENV['BS_OS_VERSION']
      capabilities['app']        = "bs://#{ENV['APP_URL']}" if ENV['APP_URL']
      capabilities['app']        = ENV['APP_ID'] if ENV['APP_ID']
      capabilities['realMobile'] = true
      capabilities['project']    = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
      capabilities['build']      = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
      capabilities['deviceOrientation']  = ENV['ORIENTATION'] if ENV['ORIENTATION']
      capabilities['browserstack.debug'] = true
      capabilities['browserstack.video'] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
      capabilities['browserstack.debug'] = 'true'

      appium_lib_options = { server_url: endpoint }
      desired_capabilities = {
          appium_lib:  appium_lib_options,
          caps:        capabilities
      }
      desired_capabilities
    end
  end
end

