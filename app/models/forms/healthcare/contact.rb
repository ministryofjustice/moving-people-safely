# frozen_string_literal: true

module Forms
  module Healthcare
    class Contact < Forms::Base
      property :contact_number, type: StrictString
      validates :contact_number, presence: true
    end
  end
end
