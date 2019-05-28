FactoryBot.define do
  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Item Name #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:image) { |n| "https://images.unsplash.com/photo-1555974849-b50fa8d1552c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80/200/300?image=#{n}" }
    sequence(:price) { |n| ("#{n}".to_i+1)*1.5 }
    sequence(:inventory) { |n| ("#{n}".to_i+1)*2 }
    active { true }
  end

  factory :inactive_item, parent: :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Inactive Item Name #{n}" }
    active { false }
  end
end
