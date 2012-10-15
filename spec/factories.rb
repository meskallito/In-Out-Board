FactoryGirl.define do
  sequence(:email)        { |n| "user#{n}@example.com" }
  sequence(:first_name)   { |n| "#{n}fn" }
  sequence(:last_name)    { |n| "#{n}ln" }

  factory :user do
    first_name
    last_name
    email
    password              '123456'
    password_confirmation '123456'
    status                'working'
  end
end