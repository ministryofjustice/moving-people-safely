FactoryBot.define do
  factory :user do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    permissions { [{'organisation' => User::ADMIN_ORGANISATION}] }

    trait :admin do
      permissions { [{'organisation' => User::ADMIN_ORGANISATION}] }
    end

    trait :police do
      permissions { [{'organisation' => User::POLICE_ORGANISATION}] }
    end

    trait :prison do
      permissions { [{'organisation' => User::PRISON_ORGANISATION}] }
    end

    trait :court do
      permissions { [{'organisation' => User::COURT_ORGANISATION}] }
    end
  end
end
