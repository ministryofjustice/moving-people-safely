# frozen_string_literal: true

module Forms
  class Feedback < ActiveModelBase
    attr_accessor :email, :message, :prisoner_number

    validates :message, presence: true
    validates :email, format: { with: /\A\S+@.+\.\S+\z/ }
  end
end
