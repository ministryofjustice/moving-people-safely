module Page
  class Dashboard < Base
    def search_escorts_due_on(date)
      begin
        page.execute_script("$('#escorts_due_on').datepicker('setDate', '#{date}')")
      rescue Capybara::NotSupportedByDriverError
        fill_in 'escorts_due_on', with: date
      end
      click_button 'Go'
    end

    def click_start_a_per
      click_link 'Start a PER'
    end

    def assert_no_escorts_due_gauges
      within '#escorts_gauges' do
        expect(page).to have_css('#detainees_gauge')
        expect(page).not_to have_css('#risk_gauge')
        expect(page).not_to have_css('#healthcare_gauge')
        expect(page).not_to have_css('#offences_gauge')
      end
    end

    def assert_no_escorts_due
      within '.search-results' do
        expect(page).not_to have_css('.escorts')
      end
    end

    def assert_escorts_due(total)
      within '.search-results' do
        within '.escorts table' do
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

    def confirm_awaiting_approval(id_number)
      within "#number_#{id_number}" do
        expect(page).to have_text('Awaiting approval')
      end
    end

    def approve(id_number)
      within "#number_#{id_number}" do
        click_link 'Approve'
      end
    end
  end
end
