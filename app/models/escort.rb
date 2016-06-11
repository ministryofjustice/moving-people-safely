class Escort < ApplicationRecord
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy

  def self.find_detainee_by_prison_number(number)
    joins(:detainee).where(detainees: { prison_number: number }).first
  end
end
