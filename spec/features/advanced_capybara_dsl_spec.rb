require 'feature_helper'

RSpec.feature 'testing advanced capybara DSL', type: :feature do
  scenario 'do stuff' do
    e = create(:escort)
    e.healthcare.destroy

    login



  end
end
