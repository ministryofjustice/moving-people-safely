require 'reform/form/coercion'

module Forms
  class Search < Reform::Form
    include Coercion
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

    def assign_attributes(attrs)
      validate(attrs)
    end

    def escort
      if valid?
        Escort.find_detainee_by_prison_number(prison_number)
      end
    end

    def invalid?
      !valid?
    end
  end
end
