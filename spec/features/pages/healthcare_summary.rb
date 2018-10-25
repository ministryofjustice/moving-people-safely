module Page
  class HealthcareSummary < Base
    include Page::AssessmentSummaryPageHelpers

    def confirm_healthcare_details(healthcare, gender = 'female')
      @healthcare = healthcare
      check_physical(healthcare, gender)
      check_mental(healthcare)
      check_transport(healthcare)
      # check_needs(healthcare)
      check_dependencies(healthcare)
      check_allergies(healthcare)
      check_social(healthcare, gender)
      # check_(healthcare)
    end

    private

    def check_physical(healthcare, gender)
      if healthcare.location == 'prison'
        check_section(healthcare, 'physical', %w[physical_issues])
      elsif healthcare.location == 'police'
        check_section(healthcare, 'physical', %w[physical_issues])
        check_section(healthcare, 'physical', %w[pregnant]) if gender == 'female'
      end
    end

    def check_mental(healthcare)
      check_section(healthcare, 'mental', %w[mental_illness])
    end

    def check_transport(healthcare)
      check_section(healthcare, 'transport', %w[mpv])
    end

    def check_dependencies(healthcare)
      if healthcare.location == 'prison'
        check_section(healthcare, 'dependencies', %w[dependencies])
      elsif healthcare.location == 'police'
        check_section(healthcare, 'dependencies', %w[alcohol_withdrawal dependencies])
      end
    end

    def check_allergies(healthcare)
      check_section(healthcare, 'allergies', %w[allergies])
    end

    def check_social(healthcare, gender)
      if healthcare.location == 'prison'
        check_section(healthcare, 'social', %w[personal_care])
      elsif healthcare.location == 'police'
        check_section(healthcare, 'social', %w[personal_care])
        check_section(healthcare, 'social', %w[female_hygiene_kit]) if gender == 'female'
      end
    end
  end
end
