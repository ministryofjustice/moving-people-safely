module Page
  class Base
    include FactoryGirl::Syntax::Methods
    include RSpec::Matchers
    include Capybara::DSL

    delegate :within, to: :Capybara

    def save_and_continue
      click_button 'Save and continue'
    end

    def confirm_and_save
      click_button 'Confirm and save'
    end

    def fill_in_optional_details(label, consideration)
      details_field_id = nil
      within_fieldset(label) do
        option = consideration.option
        if %w[ yes no ].include? option
          choose option.titlecase
          opt_field_id = find_field(option.titlecase)[:id]
          details_field_id = opt_field_id.sub("_option_#{option}", '_details')
        end
      end
      details_field = page.first(:css, "textarea##{details_field_id}") if details_field_id
      details_field.set consideration.details if details_field
    end

    def fill_in_checkbox_with_details(label, consideration)
      if consideration.on?
        check label
        id = find_field(label)[:id].append('_details')
        page.find(:css, "textarea##{id}").set consideration.details
      end
    end
  end
end
