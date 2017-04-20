module Forms
  class Search < Forms::Base
    include ::ActiveModel::Conversion

    SearchModel = Struct.new(:prison_number, :id, :persisted?)

    def initialize(*)
      super SearchModel.new(nil, nil, false)
    end

    PRISON_NUMBER_REGEX = /\A[a-z]\d{4}[a-z]{2}\z/i

    property :prison_number, type: String

    validates :prison_number,
      presence: true,
      format: { with: PRISON_NUMBER_REGEX }

    def prison_number=(value)
      value && super(value.upcase)
    end

    def escort
      @escort ||= ::Escort.find_by(_at[:prison_number].matches(prison_number)) if valid?
    end

    def detainee
      escort&.detainee
    end

    def move
      escort&.move
    end

    private

    def _at
      ::Escort.arel_table
    end
  end
end
