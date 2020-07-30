# frozen_string_literal: true

require_relative "../spec_helper"
require "capybara/rspec"
require "selenium-webdriver"

admin_user = credentials_yaml["sensu_go_backend_admin_account"]
admin_pass = credentials_yaml["sensu_go_backend_admin_password"]

readonly_user = credentials_yaml["project_readonly_user"]
readonly_pass = credentials_yaml["project_readonly_pass"]

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "https://172.16.100.254:3000"
end

# see https://docs.travis-ci.com/user/chrome#capybara
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    acceptInsecureCerts: true
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, desired_capabilities: capabilities)
end

Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome

case test_environment
when "virtualbox"
  feature "Login to sensu-backend" do
    scenario "with vaild credential of admin user" do
      sign_up_with admin_user, admin_pass

      expect(page).to have_content("local-cluster")
    end

    scenario "with vaild credential of readonly user" do
      sign_up_with readonly_user, readonly_pass

      expect(page).to have_content("local-cluster")
    end

    scenario "with invalid credential" do
      sign_up_with "foo", "bar"

      expect(page).to have_content("Sign in")
    end

    def sign_up_with(account, password)
      visit "signin"
      puts current_url
      require "pry"
      # XXX when debugging, uncomment below
      # binding.pry
      fill_in "username", with: account
      fill_in "password", with: password
      click_button "Sign in"
    end
  end
end
