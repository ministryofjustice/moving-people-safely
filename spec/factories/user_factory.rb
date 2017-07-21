FactoryGirl.define do
  factory :user do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    permissions { [{'organisation' => 'digital.noms.moj'}] }

    trait :admin do
      permissions { [{'organisation' => 'digital.noms.moj'}] }
    end
  end
end
