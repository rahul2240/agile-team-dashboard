# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@suse.com" }
    password         { Faker::Internet.password }
    birthday         { Faker::Date.birthday(16, 70) }
    name             { Faker::Name.first_name }
    surname          { Faker::Name.last_name }
    location         { Faker::Address.country }
    github_login     { Faker::Internet.user_name(name) }
  end
end
