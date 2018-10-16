# frozen_string_literal: true

module Forms
  class PoliceStationSelector
    include ActiveModel::Model

    attr_accessor :police_custody_id
    validates :police_custody_id, presence: true
  end
end
