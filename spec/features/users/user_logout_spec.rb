require 'rails_helper'

RSpec.describe "User logout, " do
  it "can log out any user who is logged in" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_path
    click_on "Log Out"

    expect(current_path).to eq(root_path)
    #to-do: check session destruction.
    #to-do: clear cart.
  end
end
