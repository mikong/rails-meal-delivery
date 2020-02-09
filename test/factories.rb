# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
  end

  factory :menu_item do
    name { Faker::Food.dish }
    price { rand(2..5) }
  end
end
