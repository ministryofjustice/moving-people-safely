module Forms
  class Offence < Forms::Base
    property :offence, type: StrictString, validates: { presence: true }
    property :case_reference, type: StrictString
    property :_delete,
      type: Types::Form::Bool,
      default: false,
      virtual: true
  end
end
