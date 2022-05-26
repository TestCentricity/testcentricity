# frozen_string_literal: true

describe TestCentricity::AppiumConnect, required: true do
  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    ENV['SELENIUM'] = ''
    ENV['WEB_BROWSER'] = 'appium'
    ENV['DEVICE_TYPE'] = 'phone'
    ENV['LOCALE'] = 'en-US'
    ENV['LANGUAGE'] = 'en'
    # start Appium server
    $server = TestCentricity::AppiumServer.new
    $server.start
  end

  context 'Mobile device simulator' do
    it 'connects to iOS Simulator using environment variables' do
      ENV['AUTOMATION_ENGINE'] = 'XCUITest'
      ENV['APP_PLATFORM_NAME'] = 'ios'
      ENV['APP_VERSION'] = '15.4'
      ENV['APP_DEVICE'] = 'iPhone 13 Pro Max'
      ENV['APP'] = Environ.current.ios_app_path
      AppiumConnect.initialize_appium
      AppiumConnect.start_driver
      expect(Environ.browser).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
      expect(Environ.driver).to eq(:appium)
      expect(Environ.device).to eq(:simulator)
      expect(Environ.device_name).to eq('iPhone 13 Pro Max')
      expect(Environ.device_os).to eq(:ios)
      expect(Environ.device_type).to eq(:phone)
      expect(Environ.device_os_version).to eq('15.4')
      expect(Environ.is_ios?).to eq(true)
    end

    it 'connects to iOS Simulator using desired_capabilities hash' do
      ENV['APP_PLATFORM_NAME'] = 'ios'
      ENV['APP_VERSION'] = '15.4'
      ENV['APP_DEVICE'] = 'iPhone 13 Pro Max'

      capabilities = {
        platformName: 'ios',
        platformVersion: '15.4',
        deviceName: 'iPhone 13 Pro Max',
        automationName: 'XCUITest',
        app: Environ.current.ios_app_path
      }
      AppiumConnect.initialize_appium(capabilities)
      AppiumConnect.start_driver
      expect(Environ.browser).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
      expect(Environ.driver).to eq(:appium)
      expect(Environ.device).to eq(:simulator)
      expect(Environ.device_name).to eq('iPhone 13 Pro Max')
      expect(Environ.device_os).to eq(:ios)
      expect(Environ.device_type).to eq(:phone)
      expect(Environ.device_os_version).to eq('15.4')
      expect(Environ.is_ios?).to eq(true)
    end

    it 'connects to Android Simulator using environment variables' do
      ENV['AUTOMATION_ENGINE'] = 'UiAutomator2'
      ENV['APP_PLATFORM_NAME'] = 'Android'
      ENV['APP_VERSION'] = '12.0'
      ENV['APP_DEVICE'] = 'Pixel_5_API_31'
      ENV['APP'] = Environ.current.android_apk_path
      AppiumConnect.initialize_appium
      AppiumConnect.start_driver
      expect(Environ.browser).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
      expect(Environ.driver).to eq(:appium)
      expect(Environ.device).to eq(:simulator)
      expect(Environ.device_name).to eq('Pixel_5_API_31')
      expect(Environ.device_os).to eq(:android)
      expect(Environ.device_type).to eq(:phone)
      expect(Environ.device_os_version).to eq('12.0')
      expect(Environ.is_android?).to eq(true)
    end

    it 'connects to Android Simulator using desired_capabilities hash' do
      ENV['APP_PLATFORM_NAME'] = 'Android'
      ENV['APP_VERSION'] = '12.0'
      ENV['APP_DEVICE'] = 'Pixel_5_API_31'

      capabilities = {
        platformName: 'Android',
        platformVersion: '12.0',
        deviceName: 'Pixel_5_API_31',
        automationName: 'UiAutomator2',
        avd: 'Pixel_5_API_31',
        app: Environ.current.android_apk_path
      }
      AppiumConnect.initialize_appium(capabilities)
      AppiumConnect.start_driver
      expect(Environ.browser).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
      expect(Environ.driver).to eq(:appium)
      expect(Environ.device).to eq(:simulator)
      expect(Environ.device_name).to eq('Pixel_5_API_31')
      expect(Environ.device_os).to eq(:android)
      expect(Environ.device_type).to eq(:phone)
      expect(Environ.device_os_version).to eq('12.0')
      expect(Environ.is_android?).to eq(true)
    end
  end

  after(:each) do
    AppiumConnect.quit_driver
    Environ.session_state = :quit
  end

  after(:context) do
    $server.stop if Environ.driver == :appium && $server.running?
  end
end
