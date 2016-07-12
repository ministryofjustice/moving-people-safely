module Forms
  class DatePicker < Forms::Base
    property :date,
      type: TextDate,
      virtual: true

    def initialize
      super(nil)
    end

    def persisted?
      true
    end

    def to_key
      []
    end
  end
end
