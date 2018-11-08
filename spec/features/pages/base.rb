module Page
  class Base
    include FactoryBot::Syntax::Methods
    include RSpec::Matchers
    include Capybara::DSL
    include Rails.application.routes.url_helpers

    delegate :within, to: :Capybara

    def save_and_continue
      click_button 'Save and continue'
    end

    def confirm_and_save
      click_button 'Confirm and save'
    end

    def fill_in_optional_details(label, model, field)
      details_field_id = nil
      within_fieldset(label) do
        option = model.public_send(field)
        opt_field = choose option: option
        opt_field_id = opt_field[:id]
        details_field_id = opt_field_id.sub("_#{option}", '_details')
      end
      details_field = page.first(:css, "textarea##{details_field_id}") if page.all("textarea##{details_field_id}").any?
      details_field.set model.public_send("#{field}_details") if details_field
    end
  end
end
