module Forms
  class Escort < Forms::Base
    property :cancelling_reason, type: String

    validates :cancelling_reason, presence: true
  end
end
