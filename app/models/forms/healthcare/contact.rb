module Forms
  module Healthcare
    class Contact < Forms::Base
      property :contact_number, type: StrictString, default: proc { default_contact_number }

      delegate :default_contact_number, to: :model
    end
  end
end
