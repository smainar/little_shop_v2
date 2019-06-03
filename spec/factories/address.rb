FactoryBot.define do
  factory :address, class: Address do
    association :user, factory: :user
    sequence(:street) { |n| "Street #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
    sequence(:nickname) { |n| "Nickname #{n}" }
  end
end
