module Detainees
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
      details.dig(:ethnicity, :desc)
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
end
