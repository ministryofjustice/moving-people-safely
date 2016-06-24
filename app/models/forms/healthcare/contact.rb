module Forms
  module Healthcare
    class Contact < Forms::Base
      property :healthcare_professional, type: StrictString
      property :contact_number, type: StrictString
    end
  end
end
