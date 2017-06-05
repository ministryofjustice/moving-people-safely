module Page
  module AssessmentSummaryPageHelpers
    def confirm_status(expected_status)
      within('header h3') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_read_only
      expect(page).not_to have_link('Change')
    end

    def click_back_to_per_page
      click_link 'View PER'
    end

    def check_section_is_all_no(doc, section, questions)
      check_change_link(doc, section)
      questions.each do |question|
        check_question_is_no(doc, section, question)
      end
    end

    def check_section(doc, section, questions)
      check_change_link(doc, section)
      questions.each do |question|
        check_question(doc, section, question)
      end
    end

    def check_change_link(doc, section)
      within("table.#{section}") do
        within('thead') { expect(page).to have_link "Change" }
      end
    end

    def check_question_is_no(doc, section, question)
      within("table.#{section}") do
        within("tr.#{question.underscore} td:nth-child(2)") do
          expect(page).to have_text('No'),
            "Expected #{section}/#{question} to be 'No': wasn't."
        end
      end
    end

    def check_question(doc, section, question)
      within("table.#{section}") do
        within("tr.#{question.underscore} td:nth-child(2)") do
          option = doc.public_send(question.to_sym)
          boolean_result = [true, false].include?(option)
          if boolean_result || option
            if boolean_result
              expected_answer = option ? 'Yes' : 'No'
            else
              expected_answer = option.titlecase
            end
            expect(page).to have_text(expected_answer),
              "Expected #{section}/#{question} to be shown: wasn't."
          else
            fail "Expected #{section}/#{question} to be shown: wasn't."
          end
        end
        within("tr.#{question.underscore} td:nth-child(3)") do
          details = "#{question}_details".to_sym
          if doc.respond_to?(details)
            expect(page).to have_text(doc.public_send details),
              "Expected more details from #{section}/#{question}: didn't get 'em."
          end
        end
      end
    end
  end
end
