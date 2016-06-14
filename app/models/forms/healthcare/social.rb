module Forms
  module Healthcare
    class Social < Forms::Base
      property :personal_hygiene,         type: StrictString, default: 'unknown'
      property :personal_hygiene_details, type: StrictString
      property :personal_care,            type: StrictString, default: 'unknown'
      property :personal_care_details,    type: StrictString

      validates :personal_hygiene,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :personal_hygiene_details,
        presence: true,
        if: -> { personal_hygiene == 'yes' }

      validates :personal_care,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :personal_care_details,
        presence: true,
        if: -> { personal_care == 'yes' }
    end
  end
end
