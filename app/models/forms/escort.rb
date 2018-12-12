# frozen_string_literal: true

module Forms
  class Escort < ActiveModelBase
    attr_accessor :cancelling_reason

    validates :cancelling_reason, presence: true
  end
end
