module Forms
  module Healthcare
    class Communication < Forms::Base
      optional_details_field :hearing_speech_sight_issues, default: 'unknown'
      optional_details_field :reading_writing_issues, default: 'unknown'
    end
  end
end
