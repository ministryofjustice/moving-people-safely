class DetaineeSearchResultsSection < SitePrism::Section
  element :profile_link, 'td:n-th-child(0) a'
  element :detainee_name, 'td:nth-child(1)'
  element :dob, 'td:nth-child(2)'
  element :destination, 'td:nth-child(3)'
  element :move_date, 'td:nth-child(4)'
end

class DatePickerSection < SitePrism::Section
  element :date_field, 'input[type="text"]'
  element :date_submit_button, 'input[value="Go"]'
  element :back_a_day_button, 'input[value="<"]'
  element :today_button, 'input[value="today"]'
  element :forward_a_day_button, 'input[value=">"]'
end

module Page
  class Dashboard < SitePrism::Page
    include FactoryGirl::Syntax::Methods
    include RSpec::Matchers
    include Capybara::DSL

    delegate :within, to: :Capybara

    set_url '/'
    sections :search_results, DetaineeSearchResultsSection, '.search_module table tr'

    section :date_picker, DatePickerSection, '.date-picker'

    element :search_field, '.search_module input#search_prison_number'
    element :search_button, '.search_module input.search_button'
    element :search_moves_due_button, '.search-header button.go'
    element :create_new_profile, 'input[type="submit"][value="Create new profile"]'

    def search(prison_number)
      fill_in 'search_prison_number', with: prison_number
      click_button 'Search'
    end

    def search_moves_due_on(date)
      begin
        page.execute_script("$('#moves_due_on').datepicker('setDate', '#{date}')")
      rescue Capybara::NotSupportedByDriverError
        fill_in 'moves_due_on', with: date
      end
      click_button 'Go'
    end

    def choose_detainee(prison_number)
      within "#prison_number_#{prison_number}" do
        click_link "#{prison_number}"
      end
    end

    def click_view_profile
      click_link 'View profile'
    end

    def click_add_new_move
      click_button 'Add new move'
    end

    def assert_no_moves_due_gauges
      within '#moves_gauges' do
        expect(page).to have_css('#detainees_gauge')
        expect(page).not_to have_css('#risk_gauge')
        expect(page).not_to have_css('#healthcare_gauge')
        expect(page).not_to have_css('#offences_gauge')
      end
    end

    def assert_no_moves_due
      within '.search-results' do
        expect(page).not_to have_css('.moves')
      end
    end

    def assert_moves_due(total)
      within '.search-results' do
        within '.moves table' do
          expect(page.all('tr.move-row').size).to eq(total)
        end
      end
    end

    def assert_total_detainees_due_to_move_gauge(total)
      within '#detainees_gauge' do
        expect(page.find('.value').text).to eq(total.to_s)
      end
    end

    def assert_incomplete_gauge(gauge, total)
      page.find("##{gauge}_gauge")[:class].include?("incomplete")
      within "##{gauge}_gauge" do
        expect(page.find('.value').text).to eq(total.to_s)
      end
    end

    def assert_complete_gauge(gauge)
      page.find("##{gauge}_gauge")[:class].include?("complete")
      within "##{gauge}_gauge" do
        expect(page.find('.value').text).to eq("✔")
      end
    end
  end
end
