# frozen_string_literal: true

module Forms
  module Risk
    class ReturnInstructions < Forms::Base
      options_field :must_return

      property :must_return_to, type: StrictString
      validates :must_return_to,
        presence: true,
        if: -> { must_return == TOGGLE_YES }

      property :must_return_to_details, type: StrictString
      validates :must_return_to_details,
        presence: true,
        if: -> { must_return == TOGGLE_YES }

      reset attributes: %i[must_return_to must_return_to_details], if_falsey: :must_return

      options_field :has_must_not_return_details
      prepopulated_collection :must_not_return_details
    end
  end
end
