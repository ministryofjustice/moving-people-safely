module Forms
  module Healthcare
    class Contact < Forms::Base
      property :clinician_name, type: StrictString
      property :contact_number, type: StrictString
    end
  end
end
