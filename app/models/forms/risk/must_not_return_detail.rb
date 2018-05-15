module Forms
  module Risk
    class MustNotReturnDetail < Forms::Base
      property :establishment,         type: StrictString
      property :establishment_details, type: StrictString
      property :_delete,
        type: Axiom::Types::Boolean,
        default: false,
        virtual: true

      validates :establishment,         presence: true
      validates :establishment_details, presence: true
    end
  end
end
