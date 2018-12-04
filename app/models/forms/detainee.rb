# frozen_string_literal: true

module Forms
  class Detainee < Forms::Base
    GENDERS = %w[male female unknown indeterminate].freeze

    property :prison_number,                type: StrictString
    property :surname,                      type: StrictString
    property :forenames,                    type: StrictString
    property :date_of_birth,                type: TextDate
    property :nationalities,                type: StrictString
    property :ethnicity,                    type: StrictString
    property :religion,                     type: StrictString
    property :gender,                       type: StrictString
    property :pnc_number,                   type: StrictString
    property :cro_number,                   type: StrictString
    property :aliases,                      type: StrictString
    property :language,                     type: StrictString
    property :security_category,            type: StrictString
    property :diet,                         type: StrictString
    property :interpreter_required,         type: StrictString
    property :interpreter_required_details, type: StrictString
    options_field_with_details :peep, allow_blank: true
    property :image_filename
    property :image

    validates :surname, :forenames, presence: true

    validates :pnc_number, :nationalities, presence: true, if: :from_police?

    validates :date_of_birth, date: { not_in_the_future: true }

    validates :gender,
      inclusion: { in: GENDERS }

    validates :interpreter_required,
      inclusion: { in: TOGGLE_CHOICES },
      if: :from_police?

    validates :interpreter_required_details, presence: true, if: -> { interpreter_required == 'yes' && from_police? }
    validates :language, presence: true, if: -> { interpreter_required == 'yes' && from_police? }

    reset attributes: %i[interpreter_required_details],
          if_falsey: :interpreter_required

    def prison_number=(value)
      value && super(value.upcase)
    end

    def genders
      GENDERS
    end
  end
end
