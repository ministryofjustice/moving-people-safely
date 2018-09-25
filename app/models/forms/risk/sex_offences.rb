module Forms
  module Risk
    class SexOffences < Forms::Base
      options_field_with_details :sex_offence, if: :from_prison?
    end
  end
end
