module Forms
  module Moves
    class Destination < Forms::Base
      MUST_RETURN_VALUES = %w[must_return must_not_return unknown].freeze

      property :establishment, type: StrictString
      property :must_return,   type: StrictString, default: 'unknown'
      property :reasons,       type: StrictString
      property :_delete,
        type: Axiom::Types::Boolean,
        default: false,
        virtual: true

      validates :must_return,
        inclusion: { in: MUST_RETURN_VALUES },
        allow_blank: true

      validates :establishment, presence: true

      def must_return_values
        MUST_RETURN_VALUES
      end
    end
  end
end
