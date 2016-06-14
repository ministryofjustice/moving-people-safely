module Forms
  module Healthcare
    class Transport < Forms::Base
      property :mpv,         type: StrictString, default: 'unknown'
      property :mpv_details, type: StrictString

      validates :mpv,
        inclusion: { in: TOGGLE_CHOICES },
        allow_blank: true

      validates :mpv_details,
        presence: true,
        if: -> { mpv == 'yes' }
    end
  end
end
