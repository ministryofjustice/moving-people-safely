module Page
  class Search < Base
    def search_prison_number(prison_number)
      fill_in 'search_prison_number', with: prison_number
      click_button 'Search'
    end

    def search_pnc_number(pnc_number)
      fill_in 'search_pnc_number', with: pnc_number
      click_button 'Search'
    end

    def click_start_new_per
      click_button 'Start new PER'
    end

    def click_continue_per
      click_link 'Continue PER'
    end
  end
end
