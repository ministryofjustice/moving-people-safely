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

    def religion
      model.religion.present? ? model.religion : 'None'
    end

    def ethnicity
      if model.ethnicity.present?
        return 'White: British' if model.ethnicity == 'White: Eng./Welsh/Scot./N.Irish/British'
        model.ethnicity
      else
        'None'
      end
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

    def expanded_interpreter_required
      return 'Not required' if model.interpreter_required == 'no'
      model.interpreter_required&.capitalize
    end

    def image
      if model.image.present?
        h.image_tag("data:image;base64,#{model.image}")
      else
        h.wicked_pdf_image_tag('photo_unavailable.png')
      end
    end

    private

    def h
      @h ||= ActionController::Base.new.view_context
    end

    def model
      __getobj__
    end
  end
end
