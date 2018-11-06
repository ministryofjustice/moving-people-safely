# frozen_string_literal: true

class Establishment < ApplicationRecord
  ESTABLISHMENT_TYPES = %i[
    crown_court
    immigration_removal_centre
    magistrates_court
    police_custody
    prison
    youth_secure_estate
  ].freeze

  belongs_to :contractor
end
