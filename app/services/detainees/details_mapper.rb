# frozen_string_literal: true

module Detainees
  # rubocop:disable Metrics/ClassLength
  class DetailsMapper
    attr_reader :prison_number, :details

    def initialize(prison_number, details)
      @prison_number = prison_number
      @details = details.with_indifferent_access
    end

    def call
      {
        prison_number: prison_number,
        forenames: mapped_forenames,
        surname: surname,
        date_of_birth: mapped_dob,
        gender: gender,
        nationalities: details[:nationalities],
        pnc_number: details[:pnc_number],
        cro_number: details[:cro_number],
        ethnicity: ethnicity,
        religion: religion,
        diet: diet,
        language: language,
        interpreter_required: interpreter_required,
        aliases: mapped_aliases,
        security_category: security_category
      }.with_indifferent_access
    end

    private

    def dob
      details[:date_of_birth]
    end

    def mapped_dob
      return unless dob.present?

      Date.parse(dob).strftime('%d/%m/%Y')
    rescue
      nil
    end

    def given_name
      details[:given_name]
    end

    def middle_names
      details[:middle_names]
    end

    def forenames
      [given_name, middle_names]
    end

    def surname
      mapped_names([details[:surname]])
    end

    def mapped_forenames
      mapped_names(forenames)
    end

    def mapped_names(names)
      present_names = names.select(&:present?)
      return if present_names.empty?

      present_names.join(' ').upcase
    end

    def gender
      details.dig(:gender, :desc)&.downcase
    end

    def ethnicity
      nomis_code = details.dig(:ethnicity, :code)
      return '' if nomis_code.blank?

      # Maps the codes from NOMIS (hash keys) to the codes we use in MPS (which
      # are the 16+1 list).
      # The comments at the end are the NOMIS descriptions.
      mps_code = {
        'A1' => 'A1', # Asian/Asian British: Indian
        'A2' => 'A2', # Asian/Asian British: Pakistani
        'A3' => 'A3', # Asian/Asian British: Bangladeshi
        'A4' => 'O1', # Asian/Asian British: Chinese
        'A9' => 'A9', # Asian/Asian British: Any other backgr'nd
        'B1' => 'B1', # Black/Black British: Caribbean
        'B2' => 'B2', # Black/Black British: African
        'B9' => 'B3', # Black/Black British: Any other Backgr'nd
        'M1' => 'M1', # Mixed: White and Black Caribbean
        'M2' => 'M2', # Mixed: White and Black African
        'M3' => 'M3', # Mixed: White and Asian
        'M9' => 'M9', # Mixed: Any other background
        'NS' => 'NS', # Prefer not to say
        'O2' => 'O9', # Other: Arab
        'O9' => 'O9', # Other: Any other background
        'W1' => 'W1', # White: Eng./Welsh/Scot./N.Irish/British
        'W2' => 'W2', # White : Irish
        'W3' => 'W9', # White: Gypsy or Irish Traveller
        'W9' => 'W9'  # White: Any other background
      }[nomis_code]

      # Get the full description so it works with the type-ahead.
      Detainee::ETHNICITY_CODES.grep(/^#{mps_code}/).first
    end

    def religion
      details.dig(:religion, :desc)
    end

    def diet
      details.dig(:diet, :desc)
    end

    def language
      details.dig(:language, :preferred_spoken, :desc)
    end

    def interpreter_required
      return 'yes' if details.dig(:language, :interpreter_required)

      'no' if details.dig(:language, :interpreter_required) == false
    end

    def aliases
      details[:aliases] || []
    end

    def security_category
      details.dig(:security_category, :desc)
    end

    def mapped_aliases
      return if aliases.empty?

      aliases.map do |a|
        names = [a['given_name'], a['middle_names'], a['surname']]
        mapped_names(names)
      end.uniq.join(', ')
    end
  end
  # rubocop:enable Metrics/ClassLength
end
