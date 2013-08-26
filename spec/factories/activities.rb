# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    user ""
    action "MyString"
    recorded_at "2013-08-26 23:32:47"
    info "MyText"
  end
end
