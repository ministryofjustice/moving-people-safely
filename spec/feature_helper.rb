require 'rails_helper'

Dir[Rails.root.join("spec/features/support/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/features/pages/*.rb")].sort.each { |f| require f }
