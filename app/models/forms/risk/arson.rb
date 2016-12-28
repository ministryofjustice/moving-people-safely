module Forms
  module Risk
    class Arson < Forms::Base
      optional_field :arson, default: 'unknown'
      optional_field :damage_to_property, default: 'unknown'
    end
  end
end
