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
  end
end
