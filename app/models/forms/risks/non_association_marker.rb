module Forms
  module Risks
    class NonAssociationMarker < Forms::Base
      property :details, type: StrictString
      property :_delete,
        type: Axiom::Types::Boolean,
        default: false,
        virtual: true

      validates :details, presence: true
    end
  end
end
