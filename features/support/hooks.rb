
BeforeAll do
  # start Appium Server if command line option was specified and target browser is mobile simulator or device
  if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium
    $server = TestCentricity::AppiumServer.new
    $server.start
  end
  # connect to sim/device and install app
  AppiumConnect.start_driver
end


AfterAll do
  # quit Appium driver
  TestCentricity::AppiumConnect.quit_driver
  # terminate Appium Server if command line option was specified and target browser is mobile simulator or device
  if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium && $server.running?
    $server.stop
  end
end


Before do |scenario|
  # if executing tests in parallel concurrent threads, print thread number with scenario name
  message = Environ.parallel ? "Thread ##{Environ.process_num} | Scenario:  #{scenario.name}" : "Scenario:  #{scenario.name}"
  log message
  $initialized ||= false
  unless $initialized
    $initialized = true
    $test_start_time = Time.now
    # HTML report header information if reporting is enabled
    log Environ.report_header if ENV['REPORTING']
  end
end


After do |scenario|
  # process and embed any screenshots recorded during execution of scenario
  process_embed_screenshots(scenario)
  # clear out any queued screenshots
  Environ.reset_contexts
  # close app
  TestCentricity::AppiumConnect.close_app
end


# exclusionary Around hooks to prevent running feature/scenario on unsupported browsers, devices, or
# cloud remote browser hosting platforms. Use the following tags to block test execution:
#   mobile devices:            @!ipad, @!iphone


# block feature/scenario execution if running against iPad mobile browser
Around('@!ipad') do |scenario, block|
  qualify_device('ipad', scenario, block)
end


# block feature/scenario execution if running against iPhone mobile browser
Around('@!iphone') do |scenario, block|
  qualify_device('iphone', scenario, block)
end


# block feature/scenario execution if running against a physical or emulated mobile device
Around('@!device') do |scenario, block|
  if Environ.is_device?
    log "Scenario '#{scenario.name}' cannot be executed on physical or emulated devices."
    skip_this_scenario
  else
    block.call
  end
end


Around('@!ios') do |scenario, block|
  if Environ.device_os == :android
    block.call
  else
    log "Scenario '#{scenario.name}' can not be executed on iOS devices."
    skip_this_scenario
  end
end


Around('@!android') do |scenario, block|
  if Environ.device_os == :ios
    block.call
  else
    log "Scenario '#{scenario.name}' can not be executed on Android devices."
    skip_this_scenario
  end
end


# supporting methods

def qualify_device(device, scenario, block)
  if Environ.is_device?
    if Environ.device_type.include? device
      log "Scenario '#{scenario.name}' cannot be executed on #{device} devices."
      skip_this_scenario
    else
      block.call
    end
  else
    block.call
  end
end

def screen_shot_and_save_page(scenario)
  timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
  filename = scenario.nil? ? "Screenshot-#{timestamp}.png" : "Screenshot-#{scenario.__id__}-#{timestamp}.png"
  path = File.join Dir.pwd, 'reports/screenshots/', filename
  if Environ.driver == :appium
    TestCentricity::AppiumConnect.take_screenshot(path)
  else
    save_screenshot path
  end
  log "Screenshot saved at #{path}"
  screen_shot = { path: path, filename: filename }
  Environ.save_screen_shot(screen_shot)
  attach(path, 'image/png') unless scenario.nil?
end

def process_embed_screenshots(scenario)
  screen_shots = Environ.get_screen_shots
  if screen_shots.count > 0
    screen_shots.each do |row|
      path = row[:path]
      attach(path, 'image/png')
    end
  else
    screen_shot_and_save_page(scenario) if scenario.failed?
  end
end
