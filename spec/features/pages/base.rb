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

    def fill_in_optional_details(label, option, details)
      details_field = nil
      within_fieldset(label) do
        opt = option.titlecase
        choose opt
        opt_field_id = find_field(opt)[:id]
        details_field_id = opt_field_id.sub("_#{option}", '_details')
        details_field = page.first(:css, "textarea##{details_field_id}")
      end
      details_field.set(details) if details_field
    end

    def fill_in_checkbox_with_details(label, option, details)
      if option == 'yes'
        check label
        id = find_field(label)[:id].append('_details')
        page.find(:css, "textarea##{id}").set(details)
      end
    end
  end
end
