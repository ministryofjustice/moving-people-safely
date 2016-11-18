module Page
  class RiskSummary < Base
    def confirm_status(expected_status)
      within('header h3') do
        expect(page).to have_content(expected_status)
      end
    end

    def confirm_risk_details(risk)
      check_section(risk, 'risk_to_self', %w[acct_status])
      check_section(risk, 'risk_from_others', %w[ rule_45 csra verbal_abuse physical_abuse ])
      if risk.violent == 'yes'
        check_section(risk, 'violence', %w[ prison_staff risk_to_females escort_or_court_staff healthcare_staff other_detainees homophobic racist public_offence_related police ])
      else
        check_section_is_all_no(risk, 'violence', %w[ prison_staff risk_to_females escort_or_court_staff healthcare_staff other_detainees homophobic racist public_offence_related police ])
      end
      if risk.stalker_harasser_bully == 'yes'
        check_section(risk, 'harassments', %w[ hostage_taker stalker harasser intimidator bully ])
      else
        check_section_is_all_no(risk, 'harassments', %w[ hostage_taker stalker harasser intimidator bully ])
      end
      check_section(risk, 'sex_offences', %w[ sex_offence ])
      check_section(risk, 'non_association_markers', %w[ non_association_markers ])
      check_section(risk, 'security', %w[ current_e_risk category_a restricted_status escape_pack escape_risk_assessment cuffing_protocol ])
      check_section(risk, 'substance_misuse', %w[ substance_supply substance_use ])
      check_section(risk, 'concealed_weapons', %w[ conceals_weapons ])
      check_section(risk, 'arson', %w[ arson damage_to_property ])
      check_section(risk, 'communication', %w[ interpreter_required hearing_speach_sight can_read_and_write ])
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
