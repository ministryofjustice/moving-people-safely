require 'feature_helper'

RSpec.feature 'testing advanced capybara DSL', type: :feature do
  scenario 'do stuff' do
    e = create(:escort)
    pn = e.detainee.prison_number
    login


    dashboard.choose_detainee(pn)

    profile.click_edit_risk


    binding.pry

    'asd'
  end
end
