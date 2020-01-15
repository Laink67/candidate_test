# frozen_string_literal: true

require 'rest-client'
require 'active_support/all'
require_relative 'helpers/rest_wrapper'
require_relative 'helpers/logger'
require 'capybara/cucumber'
require 'selenium-webdriver'
require_relative 'helpers/class_extentions'

def browser_setup(browser = 'firefox')
  case browser
  when 'chrome'
    Capybara.register_driver :chrome do |app|
      Selenium::WebDriver::Chrome.driver_path = 'configuration/chromedriver'
      profile = Selenium::WebDriver::Chrome::Profile.new
      profile['profile.default_content_settings.popups'] = 0 # custom location
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream, text/xml'
      profile['pdfjs.disabled'] = true
      Capybara::Selenium::Driver.new(app, browser: :chrome,
                                          desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
                                            'chromeOptions' => {
                                              'args' => ['--window-size=1920,1080'],
                                              'prefs' => {
                                                'download.default_directory' => Dir.pwd + '/features/tmp/',
                                                'download.prompt_for_download' => false,
                                                'plugins.plugins_disabled' => ['Chrome PDF Viewer']
                                              }
                                            }
                                          ))
    end
    Capybara.default_driver = :chrome
    Capybara.page.driver.browser.manage.window.maximize
    Capybara.default_selector = :xpath
    Capybara.default_max_wait_time = 15
  else
    Capybara.register_driver :firefox_driver do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      Selenium::WebDriver::Firefox.driver_path = 'configuration/geckodriver'
      profile['browser.download.folderList'] = 2 # custom location
      profile['browser.download.dir'] = Dir.pwd + '/features/tmp/'
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream, text/xml'
      profile['pdfjs.disabled'] = true
      Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, port: Random.rand(7000..7999))
    end
    Capybara.default_driver = :firefox_driver
  end
end
browser_setup('chrome')

configuration = YAML.load_file 'configuration/default.yml'
$rest_wrap = RestWrapper.new url: 'https://testing4qa.ediweb.ru/api',
                             **configuration[:credentials]
logger_initialize
