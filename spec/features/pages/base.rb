module Page
  class Base
    include FactoryGirl::Syntax::Methods
    include RSpec::Matchers
    include Capybara::DSL

    delegate :within, to: :Capybara

    def fill_in_optional_details(label, option, details)
      id = false
      within_fieldset(label) do
        if option == 'yes'
          choose 'Yes'
          id = find_field('Yes')[:id].sub('_yes', '_details')
        elsif option == 'no'
          choose 'No'
        end
      end
      page.find(:css, "textarea##{id}").set(details) if id
    end
  end
end
