require 'rails_helper'

Dir[Rails.root.join("spec/system/support/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/system/pages/*.rb")].sort.each { |f| require f }
