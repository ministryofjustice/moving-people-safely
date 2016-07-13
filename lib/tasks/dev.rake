namespace :dev do
  desc 'Seeds data for development environment'
  task prime: :environment do
    User.destroy_all
    User.create(
      first_name: 'Bob',
      last_name: 'Dylan',
      email: 'staff@some.prison.com',
      password: 'secret123',
      password_confirmation: 'secret123'
    )
  end

  desc 'creates some escorts for todays date'
  task escorts: :environment do
    10.times do
      e = FactoryGirl.create(:escort)
      puts "Creating #{e.detainee.forenames} #{e.detainee.surname}"
    end
  end
end
