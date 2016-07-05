module Forms
  module Risks
    class Communication < Forms::Base
      optional_details_field :hearing_speach_sight
      optional_details_field :can_read_and_write

      optional_field :interpreter_required
      property :language, type: StrictString
      validates :language,
        presence: true,
        if: -> { interpreter_required == TOGGLE_YES }
    end
  end
end
