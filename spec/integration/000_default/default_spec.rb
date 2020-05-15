# frozen_string_literal: true

require_relative "../spec_helper"
require "capybara/rspec"

admin_user = credentials_yaml["sensu_go_backend_admin_account"]
admin_pass = credentials_yaml["sensu_go_backend_admin_password"]

readonly_user = credentials_yaml["project_readonly_user"]
readonly_pass = credentials_yaml["project_readonly_pass"]

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://172.16.100.254:3000"
end
Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

case test_environment
when "virtualbox"
  feature "Login to sensu-backend" do
    scenario "with vaild credential of admin user" do
      sign_up_with admin_user, admin_pass

      expect(page).to have_content("Last executed")
    end

    scenario "with vaild credential of readonly user" do
      sign_up_with readonly_user, readonly_pass

      expect(page).to have_content("Last executed")
    end

    scenario "with invalid credential" do
      sign_up_with "foo", "bar"

      expect(page).to have_content("Sign in")
    end

    def sign_up_with(account, password)
      visit "signin"
      fill_in "username", with: account
      fill_in "password", with: password
      click_button "Sign in"
    end
  end
end
