module Forms
  module Risk
    class Arson < Forms::Base
      optional_field :arson, default: 'unknown'
    end
  end
end
