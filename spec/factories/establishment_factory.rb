FactoryGirl.define do
  factory :establishment do
    name     { "Establishment #{Faker::Number.number(3)}" }
    nomis_id { "#{Faker::Lorem.characters(2)}I".upcase }
    sso_id   { "#{Faker::Lorem.characters(6)}.noms.moj".downcase }
  end

  factory :prison, parent: :establishment do
    type 'Prison'
  end
end
