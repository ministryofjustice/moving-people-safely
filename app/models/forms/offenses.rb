module Forms
  class Offenses < Forms::Base
    property :release_date,           type: TextDate
    property :not_for_release,        type: Axiom::Types::Boolean
    property :not_for_release_reason, type: String
  end
end