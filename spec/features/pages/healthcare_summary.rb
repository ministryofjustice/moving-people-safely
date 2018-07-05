module Page
  class HealthcareSummary < Base
    include Page::AssessmentSummaryPageHelpers

    def confirm_healthcare_details(healthcare)
      @healthcare = healthcare
      check_physical(healthcare)
      check_mental(healthcare)
      check_transport(healthcare)
      # check_needs(healthcare)
      check_dependencies(healthcare)
      check_allergies(healthcare)
      check_social(healthcare)
      # check_(healthcare)
    end

    private

    def check_physical(healthcare)
      if healthcare.location == 'prison'
        check_section(healthcare, 'physical', %w[physical_issues])
      elsif healthcare.location == 'police'
        check_section(healthcare, 'physical', %w[physical_issues pregnant])
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

    def check_social(healthcare)
      if healthcare.location == 'prison'
        check_section(healthcare, 'social', %w[personal_care])
      elsif healthcare.location == 'police'
        check_section(healthcare, 'social', %w[personal_care female_hygiene_kit])
      end
    end
  end
end
