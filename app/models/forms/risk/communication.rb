module Forms
  module Risk
    class Communication < Forms::Base
      optional_field :interpreter_required
      property :language, type: StrictString
      validates :language,
        presence: true,
        if: -> { interpreter_required == TOGGLE_YES }

      reset attributes: %i[language], if_falsey: :interpreter_required

      optional_details_field :hearing_speach_sight
      optional_details_field :can_read_and_write
    end
  end
end
