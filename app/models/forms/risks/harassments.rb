module Forms
  module Risks
    class Harassments < Forms::Base
      optional_field :hostage_taker_stalker_harasser
      property :hostage_taker, type: Axiom::Types::Boolean, default: false
      property :stalker, type: Axiom::Types::Boolean, default: false
      property :harasser, type: Axiom::Types::Boolean, default: false
      property :intimidation, type: Axiom::Types::Boolean, default: false
      property :bullying, type: Axiom::Types::Boolean, default: false
    end
  end
end
