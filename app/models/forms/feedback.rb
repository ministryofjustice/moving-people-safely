# frozen_string_literal: true

module Forms
  class Feedback
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor :email, :message, :prisoner_number

    validates :message, presence: true
    validates :email, format: { with: /\A\S+@.+\.\S+\z/ }

    def initialize(attributes = {})
      @email = attributes[:email]
      @message = attributes[:message]
      @prisoner_number = attributes[:prisoner_number]
    end

    def persisted?
      false
    end
  end
end
