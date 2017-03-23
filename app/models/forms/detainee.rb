module Forms
  class Detainee < Forms::Base
    GENDERS = %w[male female].freeze

    property :prison_number, type: StrictString
    property :surname,       type: StrictString
    property :forenames,     type: StrictString
    property :date_of_birth, type: TextDate
    property :nationalities, type: StrictString
    property :gender,        type: StrictString
    property :pnc_number,    type: StrictString
    property :cro_number,    type: StrictString
    property :aliases,       type: StrictString
    property :image_filename
    property :image

    validates :surname, :forenames, presence: true

    validates :gender,
      inclusion: { in: GENDERS },
      allow_blank: true

    validate :validate_date_of_birth

    def validate_date_of_birth
      errors.add(:date_of_birth) unless date_of_birth.is_a? Date
    end

    def prison_number=(value)
      value && super(value.upcase)
    end

    def genders
      GENDERS
    end
  end
end
