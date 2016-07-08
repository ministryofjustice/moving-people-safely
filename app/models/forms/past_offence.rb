module Forms
  class PastOffence < Forms::Base
    property :offence, type: StrictString, validates: { presence: true }
    property :_delete,
      type: Axiom::Types::Boolean,
      default: false,
      virtual: true
  end
end
