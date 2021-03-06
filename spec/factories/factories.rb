require 'factory_girl'

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.password "secret"
    f.password_confirmation {|u| u.password }
  end
end
