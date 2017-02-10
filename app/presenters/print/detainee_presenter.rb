module Print
  class DetaineePresenter < SimpleDelegator
    def identifier
      "#{prison_number}: #{surname}"
    end

    def cro_number
      model.cro_number.present? ? model.cro_number : 'None'
    end

    def pnc_number
      model.pnc_number.present? ? model.pnc_number : 'None'
    end

    def date_of_birth
      model.date_of_birth.to_s(:humanized)
    end

    def gender_code
      gender == 'male' ? 'M' : 'F'
    end

    def aliases
      return %w[None] unless model.aliases.present?
      model.aliases.split(',').map(&:strip)
    end

    def nationalities
      return %w[None] unless model.nationalities.present?
      model.nationalities.split(',').map(&:strip)
    end

    private

    def model
      __getobj__
    end
  end
end
