FactoryGirl.define do
  factory :sprint do
    sequence(:number) { |n| n }
    start_date '2017-08-07'
    end_date '2017-08-18'
  end
end
