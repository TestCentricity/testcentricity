# frozen_string_literal: true

describe TestCentricity::AppiumConnect, required: true do
  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    ENV['SELENIUM'] = ''
    ENV['DRIVER'] = 'appium'
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
      expect(Environ.driver).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
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
        'appium:platformVersion': '15.4',
        'appium:deviceName': 'iPhone 13 Pro Max',
        'appium:automationName': 'XCUITest',
        'appium:app': Environ.current.ios_app_path
      }
      AppiumConnect.initialize_appium(capabilities)
      AppiumConnect.start_driver
      expect(Environ.driver).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
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
      expect(Environ.driver).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
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
        'appium:platformVersion': '12.0',
        'appium:deviceName': 'Pixel_5_API_31',
        'appium:automationName': 'UiAutomator2',
        'appium:avd': 'Pixel_5_API_31',
        'appium:app': Environ.current.android_apk_path
      }
      AppiumConnect.initialize_appium(capabilities)
      AppiumConnect.start_driver
      expect(Environ.driver).to eq(:appium)
      expect(Environ.platform).to eq(:mobile)
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
