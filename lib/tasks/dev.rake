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

  desc 'creates some moves for todays date'
  task moves: :environment do
    10.times do
      d = FactoryGirl.create(:detainee)
      d.moves << FactoryGirl.create(:move)
      puts "Creating #{d.forenames} #{d.surname}"
    end
  end
end
