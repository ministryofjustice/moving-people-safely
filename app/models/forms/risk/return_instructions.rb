module Forms
  module Risk
    class ReturnInstructions < Forms::Base
      optional_field :must_return
      property :must_return_to, type: StrictString
      property :must_return_to_details, type: StrictString
      reset attributes: %i[must_return_to must_return_to_details], if_falsey: :must_return

      validates :must_return_to, presence: true, if: -> { must_return == 'yes' }
      validates :must_return_to_details, presence: true, if: -> { must_return == 'yes' }

      optional_field :has_must_not_return_details
      prepopulated_collection :must_not_return_details
    end
  end
end
