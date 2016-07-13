class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy

  scope :for_date, ->(search_date) { where(date: search_date) }

  delegate :risks,
    :healthcare,
    :offences,
    :detainee,
    to: :escort

end
