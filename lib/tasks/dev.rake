namespace :dev do
  desc 'creates some moves for todays date'
  task moves: :environment do
    10.times do
      d = FactoryGirl.create(:detainee)
      d.moves << FactoryGirl.create(:move, :with_destinations)
      puts "Creating #{d.forenames} #{d.surname}"
    end
  end
end
