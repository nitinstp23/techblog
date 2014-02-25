FactoryGirl.define do

  factory :post do
    title 'Test Title'
    body 'Dummy Text'
  end

  factory :user do
    name 'nitin'
    password 'password'
    password_confirmation 'password'
  end

end
