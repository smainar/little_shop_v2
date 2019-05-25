# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

@user_1 = create(:user, city: "Glendale", state: "CO")
@user_2 = create(:user, city: "Glendale", state: "IA")
@user_3 = create(:user, city: "Glendale", state: "CA")
@user_4 = create(:user, city: "Golden", state: "CO")

@merchant_1 = create(:merchant)
@item_1 = create(:item, user: @merchant_1, inventory: 20)
@item_2 = create(:item, user: @merchant_1, inventory: 20)
@item_3 = create(:item, user: @merchant_1, inventory: 20)
@item_4 = create(:item, user: @merchant_1, inventory: 20)
@item_5 = create(:item, user: @merchant_1, inventory: 20)
@item_6 = create(:item, user: @merchant_1, inventory: 20)
@item_7 = create(:inactive_item, user: @merchant_1)

@merchant_2 = create(:merchant)
@item_8 = create(:item, user: @merchant_2)

#shipped orders
@order_1 = create(:shipped_order, user: @user_1)
@order_2 = create(:shipped_order, user: @user_2)
@order_3 = create(:shipped_order, user: @user_3)
@order_4 = create(:shipped_order, user: @user_4)
@order_5 = create(:shipped_order, user: @user_3)

#pending order
@order_6 = create(:order, user: @user_3)

#cancelled order
@order_7 = create(:cancelled_order, user: @user_1)

#packaged order
@order_8 = create(:packaged_order, user: @user_2)

#shipped orders
@order_item_1 = create(:fulfilled_order_item, item: @item_1, quantity: 2, order: @order_1)
@order_item_2 = create(:fulfilled_order_item, item: @item_2, quantity: 7, order: @order_2)
@order_item_3 = create(:fulfilled_order_item, item: @item_5, quantity: 10, order: @order_3)
@order_item_4 = create(:fulfilled_order_item, item: @item_4, quantity: 5, order: @order_4)
@order_item_5 = create(:fulfilled_order_item, item: @item_3, quantity: 4, order: @order_4)
@order_item_6 = create(:fulfilled_order_item, item: @item_3, quantity: 2, order: @order_5)

@order_item_13 = create(:fulfilled_order_item, item: @item_2, quantity: 5, order: @order_1)
@order_item_14 = create(:fulfilled_order_item, item: @item_6, quantity: 3, order: @order_1)
@order_item_15 = create(:fulfilled_order_item, item: @item_8, quantity: 18, order: @order_1)

#not shipped orders
@order_item_7 = create(:order_item, item: @item_1, order: @order_6)
@order_item_8 = create(:order_item, item: @item_1, order: @order_7)
@order_item_9 = create(:order_item, item: @item_1, order: @order_8)

@order_item_10 = create(:fulfilled_order_item, item: @item_2, order: @order_6)
@order_item_11 = create(:fulfilled_order_item, item: @item_2, order: @order_7)
@order_item_12 = create(:fulfilled_order_item, item: @item_2, order: @order_8)

# admin = create(:admin)
# user = create(:user)
# merchant_1 = create(:merchant)
# existing_user = create(:user, email: "existingemail@gmail.com")
#
# merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)
#
# inactive_merchant_1 = create(:inactive_merchant)
# inactive_user_1 = create(:inactive_user)
#
# item_1 = create(:item, user: merchant_1)
# item_2 = create(:item, user: merchant_2)
# create_list(:item, 10, user: merchant_1)
#
# inactive_item_1 = create(:inactive_item, user: merchant_1)
# inactive_item_2 = create(:inactive_item, user: inactive_merchant_1)
#
# Random.new_seed
# rng = Random.new

# # pending order, none fulfilled
# order = create(:order, user: user)
# create(:order_item, order: order, item: item_1, price: 1, quantity: 1)
# create(:order_item, order: order, item: item_2, price: 2, quantity: 1)
#
# # pending order, partially fulfilled
# order = create(:order, user: user)
# create(:order_item, order: order, item: item_1, price: 1, quantity: 1)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).days.ago, updated_at: rng.rand(23).hours.ago)
#
# # packaged order
# order = create(:packaged_order, user: user)
# create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(3)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
#
# # shipped order, cannot be cancelled
# order = create(:shipped_order, user: user)
# create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(3)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
#
# # cancelled order
# order = create(:cancelled_order, user: user)
# create(:order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
# #create(:order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)


puts 'seed data finished'
puts "Users created: #{User.count.to_i}"
puts "Orders created: #{Order.count.to_i}"
puts "Items created: #{Item.count.to_i}"
puts "OrderItems created: #{OrderItem.count.to_i}"
