module Forms
  module Healthcare
    class Needs < Forms::Base
      property :dependencies,         type: StrictString, default: 'unknown'
      property :dependencies_details, type: StrictString
      property :medication,           type: StrictString, default: 'unknown'
      # property :medications,        type: Arary

      validates :dependencies,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :dependencies_details,
        presence: true,
        if: -> { dependencies == 'yes' }

      validates :medication,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true
    end
  end
end
