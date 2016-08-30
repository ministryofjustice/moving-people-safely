module Forms
  module Risk
    class Communication < Forms::Base
      optional_field :interpreter_required
      property :language, type: StrictString
      validates :language,
        presence: true,
        if: -> { interpreter_required == ::Risk.interpreter_required_on_values[0] }

      reset attributes: ::Risk.children_of(:interpreter_required), if_falsey: :interpreter_required

      optional_details_field :hearing_speach_sight
      optional_details_field :can_read_and_write
    end
  end
end
