# frozen_string_literal: true

FactoryBot.define do
  factory :absence do
    name        { Faker::Cat.name }
    location    { Faker::Address.street_name }
    end_date    { Faker::Date.forward(30) }
    start_date  { Faker::Date.backward(15) }
    event_type  { Absence::TYPES.sample }
    user_id     user
  end
end
