require 'rails_helper'
require 'site_prism'

Dir[Rails.root.join("spec/features/pages/*.rb")].each { |f| require f }
