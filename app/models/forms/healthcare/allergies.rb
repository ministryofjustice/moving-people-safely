module Forms
  module Healthcare
    class Allergies < Forms::Base
      property :allergies,         type: StrictString, default: 'unknown'
      property :allergies_details, type: StrictString

      validates :allergies,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :allergies_details,
        presence: true,
        if: -> { allergies == 'yes' }
    end
  end
end
