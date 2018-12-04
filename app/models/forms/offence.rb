# frozen_string_literal: true

module Forms
  class Offence < Forms::Base
    property :offence, type: StrictString, validates: { presence: true }
    property :case_reference, type: StrictString
    property :_delete,
      type: Axiom::Types::Boolean,
      default: false,
      virtual: true
  end
end
