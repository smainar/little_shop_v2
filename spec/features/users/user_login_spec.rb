require 'rails_helper'

RSpec.describe "User Login Workflow", type: :feature do

  scenario 'correct user login information entered' do
    user = User.create!(email: "abc@abc.com", password: "password", name: "user1", address: "kgysdfklvysgu", city: 'city town', state: 'state place', zip: '987123', role: 'user')

    visit root_path
    click_on 'Login'

    expect(current_path).to eq(login_path)

    within('.login-form') do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Login"
    end
    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Welcome, #{user.name}!")
  end

  scenario 'incorrect user login information entered' do
    user = User.create!(email: "abc@abc.com", password: "password", name: "user1", address: "kgysdfklvysgu", city: 'city town', state: 'state place', zip: '987123', role: 'user')

    visit login_path

    within('.login-form') do
      fill_in "Email", with: user.email
      fill_in "Password", with: 'wrongpassword'
      click_on "Login"
    end

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Incorrect Username/Password Combination")
  end

  scenario 'admin user logs in' do
    admin = User.create!(email: "jkhbwljb@gmail.com", password: "password", name: "admin1", address: "kgysdfklvysgu", city: 'city town', state: 'state place', zip: '987123', role: 'admin')

    visit login_path

    within('.login-form') do
      fill_in "Email", with: admin.email
      fill_in "Password", with: admin.password
      click_on "Login"
    end

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Welcome, #{admin.name}!")
  end

  scenario 'merchant user logs in' do
    merchant = User.create!(email: "jkhbwljb@gmail.com", password: "password", name: "merchant1", address: "kgysdfklvysgu", city: 'city town', state: 'state place', zip: '987123', role: 'merchant')

    visit login_path

    within('.login-form') do
      fill_in "Email", with: merchant.email
      fill_in "Password", with: merchant.password
      click_on "Login"
    end

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{merchant.name}!")
  end
end
