module Page
  class RiskSummary < Base
    def confirm_status(expected_status)
      within('header h3') do
        expect(page).to have_content(expected_status)
      end
    end
  end
end
