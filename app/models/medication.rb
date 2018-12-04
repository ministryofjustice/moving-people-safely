# frozen_string_literal: true

class Medication < ApplicationRecord
  belongs_to :healthcare
  delegate :location, to: :healthcare
end
