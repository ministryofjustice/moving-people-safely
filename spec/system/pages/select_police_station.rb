module Page
  class SelectPoliceStation < Base
    def select_station(name)
      fill_in 'police_station_selector_police_custody_id', with: "#{name}\n"
      save_and_continue
    end

    def expect_error_message
      expect(page).to have_content 'Please select a police custody suite'
    end
  end
end
