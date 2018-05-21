module Forms
  class Search
    include ActiveModel::Validations
    include ActiveModel::Conversion

    PRISON_NUMBER_REGEX = /\A[a-z]\d{4}[a-z]{2}\z/i

    attr_accessor :prison_number

    validates :prison_number,
      presence: true,
      format: { with: PRISON_NUMBER_REGEX }

    def persisted?
      false
    end
  end
end
