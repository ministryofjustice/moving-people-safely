module Forms
  module Healthcare
    class Mental < Forms::Base
      property :mental_illness,         type: StrictString, default: 'unknown'
      property :mental_illness_details, type: StrictString
      property :phobias,                type: StrictString, default: 'unknown'
      property :phobias_details,        type: StrictString

      validates :mental_illness,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :mental_illness_details,
        presence: true,
        if: -> { mental_illness == 'yes' }

      validates :phobias,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :phobias_details,
        presence: true,
        if: -> { phobias == 'yes' }
    end
  end
end
