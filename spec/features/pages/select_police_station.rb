module Page
  class SelectPoliceStation < Base
    def select_station(name)
      select name, from: 'Police custody suite'
      save_and_continue
    end

    def expect_error_message
      expect(page).to have_content 'Please select a police custody suite'
    end
  end
end
