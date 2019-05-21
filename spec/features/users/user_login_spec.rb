require 'rails_helper'

RSpec.describe "User Login Workflow", type: :feature do
  before :each do
    @user = User.create!(email: "abc@abc.com", password: "password", name: "user1", address: "kgysdfklvysgu", city: 'city town', state: 'state place', zip: '987123')
  end

  scenario 'correct login information entered' do
    visit root_path
    click_on 'Login'

    expect(current_path).to eq(login_path)

    within('.login-form') do
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password_digest
      click_on "Login"
    end
    expect(current_path).to eq(profile_path)
  end
end
