require 'rails_helper'

RSpec.describe 'Admin Order Index', type: :feature do
  context 'as an admin' do
    it 'should display all orders and correct info' do
      admin = create(:admin)
      user_w_order_1 = create(:user)
      user_w_order_2 = create(:user)
      user_w_order_3 = create(:user)
      user_w_order_4 = create(:user)
      order_1 = create(:packaged_order, user: user_w_order_1)
      order_2 = create(:pending_order, user: user_w_order_2)
      order_3 = create(:shipped_order, user: user_w_order_3)
      order_4 = create(:cancelled_order, user: user_w_order_4)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_dashboard_path

      expect(page.all("div")[0]).to have_content(order_1.user.name)
      expect(page.all("div")[0]).to have_content(order_1.created_at)
      expect(page.all("div")[0]).to have_content(order_1.id)
      expect(page.all("div")[0]).to have_content(order_1.status)

      expect(page.all("div")[1]).to have_content(order_2.user.name)
      expect(page.all("div")[1]).to have_content(order_2.created_at)
      expect(page.all("div")[1]).to have_content(order_2.id)
      expect(page.all("div")[1]).to have_content(order_2.status)

      expect(page.all("div")[2]).to have_content(order_3.user.name)
      expect(page.all("div")[2]).to have_content(order_3.created_at)
      expect(page.all("div")[2]).to have_content(order_3.id)
      expect(page.all("div")[2]).to have_content(order_3.status)

      expect(page.all("div")[3]).to have_content(order_4.user.name)
      expect(page.all("div")[3]).to have_content(order_4.created_at)
      expect(page.all("div")[3]).to have_content(order_4.id)
      expect(page.all("div")[3]).to have_content(order_4.status)




    end
  end


end
