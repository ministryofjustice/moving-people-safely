module Page
  class Base
    include FactoryGirl::Syntax::Methods
    include RSpec::Matchers
    include Capybara::DSL

    delegate :within, to: :Capybara
  end
end
