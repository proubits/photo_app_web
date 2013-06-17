# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    taker "1234567890-0404556688"
    taker_id "1234567890"
    taker_no "0404556688"
    location "333311112222-999999"
    name "20120530002439"
    user_id 1
  end
end
