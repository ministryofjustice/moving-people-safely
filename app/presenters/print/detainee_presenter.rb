module Print
  class DetaineePresenter < SimpleDelegator
    include WickedPdf::WickedPdfHelper::Assets
    include ActionView::Helpers::AssetTagHelper

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

    def image
      if model.image.present?
        image_tag("data:image;base64,#{model.image}")
      else
        wicked_pdf_image_tag('photo_unavailable.png')
      end
    end

    private

    def model
      __getobj__
    end
  end
end
