require 'appium_lib'
require 'curb'
require 'json'


module TestCentricity
  module AppiumConnect

    attr_accessor :running
    attr_accessor :endpoint
    attr_accessor :capabilities

    def self.initialize_appium(options = nil)
      @endpoint = nil
      @capabilities = nil
      if options.is_a?(Hash)
        @endpoint = options[:endpoint] if options.key?(:endpoint)
        @capabilities = options[:desired_capabilities] if options.key?(:desired_capabilities)
      end
      Environ.platform = :mobile
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']

      Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
      Environ.device_os_version = ENV['APP_VERSION']
      Environ.driver = ENV['DRIVER'].downcase.to_sym
      case Environ.driver
      when :appium
        Environ.device_name = ENV['APP_DEVICE']
        Environ.device_os = ENV['APP_PLATFORM_NAME']
        Environ.device = ENV['UDID'] ? :device : :simulator
      when :browserstack
        Environ.device_name = ENV['BS_DEVICE']
        Environ.device_os = ENV['BS_OS']
        Environ.device = :device
        upload_app(:browserstack) if ENV['UPLOAD_APP']
      when :saucelabs
        Environ.device_name = ENV['SL_DEVICE']
        Environ.device_os = ENV['SL_OS']
      when :testingbot
        Environ.device_name = ENV['TB_DEVICE']
        Environ.device_os = ENV['TB_OS']
        Environ.device = :device
        upload_app(:testingbot) if ENV['UPLOAD_APP']
      when :lambdatest
        Environ.device_name = ENV['LT_DEVICE']
        Environ.device_os = ENV['LT_OS']
      else
        raise "#{Environ.driver} is not a valid selector"
      end
      @running = false
    end

    def self.start_driver
      capabilities = case Environ.driver
                     when :appium
                       appium_local_capabilities
                     when :browserstack
                       browserstack_capabilities
                     when :saucelabs
                       sauce_capabilities
                     when :testingbot
                       testingbot_capabilities
                     when :lambdatest
                       lambdatest_capabilities
                     else
                       raise "#{Environ.driver} is not a valid selector"
                     end
      puts "Appium desired_capabilities = #{capabilities}" if ENV['DEBUG']

      desired_capabilities = {
        caps: capabilities,
        appium_lib: { server_url: @endpoint }
      }
      Appium::Driver.new(desired_capabilities, true).start_driver
      @running = true
      Appium.promote_appium_methods(TestCentricity::ScreenObject)
      Appium.promote_appium_methods(TestCentricity::ScreenSection)
      Appium.promote_appium_methods(TestCentricity::AppUIElement)

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

    def self.app_installed?(bundle_id = nil)
      $driver.app_installed?(get_app_id(bundle_id))
    end

    def self.launch_app
      $driver.launch_app
    end

    def self.background_app(duration)
      $driver.background_app(duration)
    end

    def self.close_app
      $driver.close_app
    end

    def self.reset_app
      $driver.reset
    end

    def self.remove_app(bundle_id = nil)
      $driver.remove_app(get_app_id(bundle_id))
    end

    def self.activate_app(bundle_id = nil)
      $driver.activate_app(get_app_id(bundle_id))
    end

    def self.app_state(bundle_id = nil)
      $driver.app_state(get_app_id(bundle_id))
    end

    def self.terminate_app(bundle_id = nil)
      $driver.terminate_app(get_app_id(bundle_id))
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

    def self.orientation
      $driver.orientation
    end

    def self.set_orientation(orientation)
      $driver.rotation = orientation.downcase.to_sym
    end

    def self.geolocation
      $driver.location
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
      contexts = $driver.available_contexts
      puts "Contexts = #{contexts}" if ENV['DEBUG']
      set_context(contexts.last)
      puts "Current context = #{$driver.current_context}" if ENV['DEBUG']
    end

    def self.upload_app(service)
      case service
      when :browserstack
        url = 'https://api-cloud.browserstack.com/app-automate/upload'
        user_id = ENV['BS_USERNAME']
        auth_key = ENV['BS_AUTHKEY']
      when :testingbot
        url = 'https://api.testingbot.com/v1/storage'
        user_id = ENV['TB_USERNAME']
        auth_key = ENV['TB_AUTHKEY']
      else
        raise "#{service} is not a valid selector"
      end

      file_path = if Environ.is_android?
                    Environ.current.android_apk_path
                  elsif Environ.is_ios?
                    Environ.is_device? ?
                      Environ.current.ios_ipa_path :
                      Environ.current.ios_app_path
                  end

      c = Curl::Easy.new(url)
      c.http_auth_types = :basic
      c.username = user_id
      c.password = auth_key
      c.multipart_form_post = true
      c.http_post(Curl::PostField.file('file', file_path))
      result = JSON.parse(c.body_str)
      puts "app_url = #{result['app_url']}"
      ENV['APP'] = result['app_url']
    end

    private

    def self.get_app_id(bundle_id = nil)
      return bundle_id unless bundle_id.nil?

      if Environ.is_ios?
        Environ.current.ios_bundle_id
      elsif Environ.is_android?
        Environ.current.android_app_id
      else
        nil
      end
    end

    def self.appium_local_capabilities
      # specify endpoint url
      @endpoint = 'http://127.0.0.1:4723/wd/hub' if @endpoint.nil?
      # define local Appium capabilities
      if @capabilities.nil?
        caps = {
          platformName: ENV['APP_PLATFORM_NAME'],
          platformVersion: ENV['APP_VERSION'],
          deviceName: ENV['APP_DEVICE'],
          automationName: ENV['AUTOMATION_ENGINE']
        }
        caps[:avd] = ENV['APP_DEVICE'] if ENV['APP_PLATFORM_NAME'].downcase.to_sym == :android
        caps[:orientation] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
        caps[:language] = ENV['LANGUAGE'] if ENV['LANGUAGE']
        if ENV['LOCALE']
          caps[:locale] = if Environ.is_android?
                            locale = ENV['LOCALE'].gsub('-', '_')
                            locale.split('_')[1]
                          else
                            ENV['LOCALE'].gsub('-', '_')
                          end
        end
        caps[:newCommandTimeout] = ENV['NEW_COMMAND_TIMEOUT'] if ENV['NEW_COMMAND_TIMEOUT']
        caps[:noReset] = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
        caps[:fullReset] = ENV['APP_FULL_RESET'] if ENV['APP_FULL_RESET']
        caps[:autoLaunch] = ENV['AUTO_LAUNCH'] if ENV['AUTO_LAUNCH']
        caps[:webkitDebugProxyPort] = ENV['WEBKIT_DEBUG_PROXY_PORT'] if ENV['WEBKIT_DEBUG_PROXY_PORT']
        caps[:webDriverAgentUrl] = ENV['WEBDRIVER_AGENT_URL'] if ENV['WEBDRIVER_AGENT_URL']
        caps[:wdaLocalPort] = ENV['WDA_LOCAL_PORT'] if ENV['WDA_LOCAL_PORT']
        caps[:usePrebuiltWDA] = ENV['USE_PREBUILT_WDA'] if ENV['USE_PREBUILT_WDA']
        caps[:useNewWDA] = ENV['USE_NEW_WDA'] if ENV['USE_NEW_WDA']
        caps[:autoWebview] = ENV['AUTO_WEBVIEW'] if ENV['AUTO_WEBVIEW']
        caps[:chromedriverExecutable] = ENV['CHROMEDRIVER_EXECUTABLE'] if ENV['CHROMEDRIVER_EXECUTABLE']
        caps[:autoWebviewTimeout] = ENV['AUTO_WEBVIEW_TIMEOUT'] if ENV['AUTO_WEBVIEW_TIMEOUT']
        caps[:udid] = ENV['UDID'] if ENV['UDID']
        caps[:xcodeOrgId] = ENV['TEAM_ID'] if ENV['TEAM_ID']
        caps[:xcodeSigningId] = ENV['TEAM_NAME'] if ENV['TEAM_NAME']
        caps[:appActivity] = ENV['APP_ACTIVITY'] if ENV['APP_ACTIVITY']
        caps[:appPackage] = ENV['APP_PACKAGE'] if ENV['APP_PACKAGE']
        caps[:webviewConnectTimeout] = '90000'

        if ENV['BUNDLE_ID']
          caps[:bundleId] = ENV['BUNDLE_ID']
        else
          app_id = get_app_id
          caps[:bundleId] = app_id unless app_id.nil?
        end

        caps[:app] = if ENV['APP']
                       ENV['APP']
                     else
                       if Environ.is_android?
                         Environ.current.android_apk_path
                       elsif Environ.is_ios?
                         Environ.is_device? ?
                           Environ.current.ios_ipa_path :
                           Environ.current.ios_app_path
                       end
        end
        caps
      else
        @capabilities
      end
    end

    # :nocov:
    def self.browserstack_capabilities
      # specify endpoint url
      @endpoint = 'http://hub-cloud.browserstack.com/wd/hub' if @endpoint.nil?
      # define BrowserStack options
      options = if @capabilities.nil?
                  # define the required set of BrowserStack options
                  bs_options = {
                    userName: ENV['BS_USERNAME'],
                    accessKey: ENV['BS_AUTHKEY'],
                    sessionName: test_context_message
                  }
                  # define the optional BrowserStack options
                  bs_options[:projectName] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  bs_options[:buildName] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
                  bs_options[:geoLocation] = ENV['IP_GEOLOCATION'] if ENV['IP_GEOLOCATION']
                  bs_options[:timezone] = ENV['TIME_ZONE'] if ENV['TIME_ZONE']
                  bs_options[:video] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  bs_options[:debug] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  bs_options[:local] = ENV['TUNNELING'] if ENV['TUNNELING']
                  bs_options[:deviceOrientation] = ENV['ORIENTATION'] if ENV['ORIENTATION']
                  bs_options[:appiumLogs] = ENV['APPIUM_LOGS'] if ENV['APPIUM_LOGS']
                  bs_options[:networkLogs] = ENV['NETWORK_LOGS'] if ENV['NETWORK_LOGS']
                  bs_options[:deviceLogs] = ENV['DEVICE_LOGS'] if ENV['DEVICE_LOGS']
                  bs_options[:networkProfile] = ENV['NETWORK_PROFILE'] if ENV['NETWORK_PROFILE']
                  bs_options[:idleTimeout] = ENV['IDLE_TIMEOUT'] if ENV['IDLE_TIMEOUT']
                  bs_options[:resignApp] = ENV['RESIGN_APP'] if ENV['RESIGN_APP']
                  bs_options[:gpsLocation] = ENV['GPS_LOCATION'] if ENV['GPS_LOCATION']
                  bs_options[:acceptInsecureCerts] = ENV['ACCEPT_INSECURE_CERTS'] if ENV['ACCEPT_INSECURE_CERTS']
                  bs_options[:disableAnimations] = ENV['DISABLE_ANIMATION'] if ENV['DISABLE_ANIMATION']
                  bs_options[:appiumVersion] = if ENV['APPIUM_VERSION']
                                                 ENV['APPIUM_VERSION']
                                               else
                                                 '1.22.0'
                                               end
                  capabilities = {
                    platformName: ENV['BS_OS'],
                    platformVersion: ENV['BS_OS_VERSION'],
                    deviceName: ENV['BS_DEVICE'],
                    app: ENV['APP'],
                    'bstack:options': bs_options
                  }
                  capabilities[:language] = ENV['LANGUAGE'] if ENV['LANGUAGE']
                  capabilities[:locale] = ENV['LOCALE'] if ENV['LOCALE']
                  capabilities
                else
                  @capabilities
                end
      options
    end

    def self.sauce_capabilities
      # specify endpoint url
      @endpoint = "https://#{ENV['SL_USERNAME']}:#{ENV['SL_AUTHKEY']}@ondemand.#{ENV['DATA_CENTER']}.saucelabs.com:443/wd/hub" if @endpoint.nil?
      # define SauceLab options
      options = if @capabilities.nil?
                  capabilities = {
                    platformName: ENV['SL_OS'],
                    app: ENV['APP'],
                    deviceName: ENV['SL_DEVICE'],
                    platformVersion: ENV['SL_OS_VERSION'],
                    deviceType: ENV['DEVICE_TYPE'],
                    build: test_context_message
                  }
                  capabilities[:name] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  capabilities[:deviceOrientation] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
                  capabilities[:recordVideo] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  capabilities[:recordScreenshots] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  capabilities[:appiumVersion] = if ENV['APPIUM_VERSION']
                                                 ENV['APPIUM_VERSION']
                                               else
                                                 '1.22.3'
                                                 end
                  capabilities
                else
                  @capabilities
                end
      options
    end

    def self.testingbot_capabilities
      # specify endpoint url
      @endpoint = "http://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com/wd/hub" if @endpoint.nil?
      # define TestingBot options
      options = if @capabilities.nil?
                  capabilities = {
                    user: ENV['TB_USERNAME'],
                    accessKey: ENV['TB_AUTHKEY'],
                    platformName: ENV['TB_OS'],
                    app: ENV['APP'],
                    deviceName: ENV['TB_DEVICE'],
                    version: ENV['TB_OS_VERSION'],
                    build: test_context_message
                  }
                  capabilities[:realDevice] = ENV['REAL_DEVICE'].to_bool if ENV['REAL_DEVICE']
                  capabilities[:name] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  capabilities
                else
                  @capabilities
                end
      options
    end

    def self.lambdatest_capabilities
      # specify endpoint url
      @endpoint = "https://#{ENV['LT_USERNAME']}:#{ENV['LT_AUTHKEY']}@beta-hub.lambdatest.com/wd/hub" if @endpoint.nil?
      # define LambdaTest options
      options = if @capabilities.nil?
                  # define the required set of LambdaTest options
                  lt_options = {
                    deviceName: ENV['LT_DEVICE'],
                    platformName: ENV['LT_OS'],
                    platformVersion: ENV['LT_OS_VERSION'],
                    app: ENV['APP'],
                    w3c: true,
                    build: test_context_message
                  }
                  # define the optional LambdaTest options
                  lt_options[:name] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  lt_options[:isRealMobile] = ENV['REAL_DEVICE'].to_bool if ENV['REAL_DEVICE']
                  lt_options[:deviceOrientation] = ENV['ORIENTATION'] if ENV['ORIENTATION']
                  lt_options[:geoLocation] = ENV['GEO_LOCATION'] if ENV['GEO_LOCATION']
                  lt_options[:video] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  lt_options[:visual] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  lt_options[:network] = ENV['NETWORK_LOGS'] if ENV['NETWORK_LOGS']
                  lt_options[:deviceLogs] = ENV['DEVICE_LOGS'] if ENV['DEVICE_LOGS']
                  lt_options[:tunnel] = ENV['TUNNELING'] if ENV['TUNNELING']
                  lt_options[:idleTimeout] = ENV['IDLE_TIMEOUT'] if ENV['IDLE_TIMEOUT']

                  { 'LT:Options': lt_options }
                else
                  @capabilities
                end
      options
    end

    def self.test_context_message
      context_message = if ENV['TEST_CONTEXT']
                          "#{Environ.test_environment.to_s.upcase} - #{ENV['TEST_CONTEXT']}"
                        else
                          Environ.test_environment.to_s.upcase
                        end
      if ENV['PARALLEL']
        thread_num = ENV['TEST_ENV_NUMBER']
        thread_num = 1 if thread_num.blank?
        context_message = "#{context_message} - Thread ##{thread_num}"
      end
      context_message
    end
    # :nocov:
  end
end

