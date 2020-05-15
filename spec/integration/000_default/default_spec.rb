# frozen_string_literal: true

require_relative "../spec_helper"
require "capybara/rspec"

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://172.16.100.254:3000"
end
Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

case test_environment
when "virtualbox"
  feature "Login to sensu-backend" do
    scenario "with vaild credential" do
      sign_up_with "admin", "P@ssw0rd!"

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
