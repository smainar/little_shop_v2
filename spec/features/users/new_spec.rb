require 'rails_helper'

RSpec.describe "User Registration form" do
  it "can create new user" do
    visit root_path

    click_on 'Register'

    expect(current_path).to eq('/register')

    fill_in "user[name]", with: "Billy"
    fill_in "user[email]", with: "billyurrutia@gmail.com"
    fill_in "user[password]", with: "1233"
    fill_in "user[password_confirmation]", with: "1233"
    fill_in "user[addresses_attributes][0][street]", with: "123 go to santa lane"
    fill_in "user[addresses_attributes][0][city]", with: "aurora"
    fill_in "user[addresses_attributes][0][state]", with: "colorado"
    fill_in "user[addresses_attributes][0][zip]", with: "123311"

    click_on "Register User"

    expect(current_path).to eq('/profile')

    new_user = User.last

    expect(page).to have_content("Welcome, #{new_user.name}")
  end

  context "put in wrong confirmation password" do
    it 'brings you back to the register page' do
      visit root_path

      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in "user[name]", with: "Billy"
      fill_in "user[email]", with: "billyurrutia@gmail.com"
      fill_in "user[password]", with: "1233"
      fill_in "user[password_confirmation]", with: "123"
      fill_in "user[addresses_attributes][0][street]", with: "123 go to santa lane"
      fill_in "user[addresses_attributes][0][city]", with: "aurora"
      fill_in "user[addresses_attributes][0][state]", with: "colorado"
      fill_in "user[addresses_attributes][0][zip]", with: "123311"

      click_on "Register User"

      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  context 'email in use already' do
    it 'gives flash error email in use' do
      create(:user, email: "ABC@gmail.com")

      visit '/register'

      fill_in "user[name]", with: "Billy"
      fill_in "user[email]", with: "abc@gmail.com"
      fill_in "user[password]", with: "1233"
      fill_in "user[password_confirmation]", with: "1233"
      fill_in "user[addresses_attributes][0][street]", with: "123 go to santa lane"
      fill_in "user[addresses_attributes][0][city]", with: "aurora"
      fill_in "user[addresses_attributes][0][state]", with: "colorado"
      fill_in "user[addresses_attributes][0][zip]", with: "123311"

      click_on "Register User"

      expect(page).to have_content("Email has already been taken")

      fill_in 'user[email]', with: "abc123@gmail.com"
      fill_in "user[password]", with: "1233"
      fill_in "user[password_confirmation]", with: "1233"

      click_on "Register User"

      expect(current_path).to eq('/profile')

      new_user = User.last

      expect(page).to have_content("Welcome, #{new_user.name}")
    end
  end
end
