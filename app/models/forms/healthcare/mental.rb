module Forms
  module Healthcare
    class Mental < Forms::Base
      optional_details_field :mental_illness
      optional_details_field :phobias
    end
  end
end
