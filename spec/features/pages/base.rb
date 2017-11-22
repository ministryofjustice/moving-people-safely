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
        choose option.titlecase
        opt_field_id = find_field(option.titlecase)[:id]
        details_field_id = opt_field_id.sub("_#{option}", '_details')
      end
      details_field = page.first(:css, "textarea##{details_field_id}") if details_field_id
      details_field.set optional_detail_value(model, field) if details_field
    end

    def fill_in_checkbox_with_details(label, model, field)
      if model.public_send(field) == 'yes'
        check label
        id = find_field(label)[:id].append('_details')
        page.find(:css, "textarea##{id}").set optional_detail_value(model, field)
      end
    end

    private

    def optional_detail_value(model, option_field)
      model.public_send("#{option_field}_details")
    end
  end
end
