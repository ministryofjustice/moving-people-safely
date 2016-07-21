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
      completenesses = %w[healthcare risk offences].shuffle.take(rand(4)).map { |w| "with_incomplete_#{w}".to_sym }
      e = FactoryGirl.create(:escort, *completenesses)
      puts "Creating #{e.detainee.forenames} #{e.detainee.surname} #{completenesses}"
    end
  end
end
