module Forms
  module Risk
    class Arson < Forms::Base
      options_field :arson, if: :from_prison?
    end
  end
end
