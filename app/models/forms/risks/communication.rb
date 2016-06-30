module Forms
  module Risks
    class Communication < Forms::Base
      optional_details_field :interpreter_required
      optional_details_field :hearing_speach_sight
      optional_details_field :can_read_and_write
    end
  end
end
