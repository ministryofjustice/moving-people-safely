class Offence < ApplicationRecord
  belongs_to :escort

  delegate :editable?, :location, to: :escort
end
