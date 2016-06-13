module Forms
  module Healthcare
    class Physical < Forms::Base
      property :physical_issues,         type: StrictString, default: 'unknown'
      property :physical_issues_details, type: StrictString

      validates :physical_issues,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true
      validates :physical_issues_details,
        presence: true,
        if: -> { physical_issues == 'yes' }
    end
  end
end
