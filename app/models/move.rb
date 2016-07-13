class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy

  has_one :detainee, through: :escort
  has_one :healthcare, through: :escort
  has_one :offences, through: :escort
  has_one :risks, through: :escort


  scope :for_date, ->(search_date) do
    where(date: search_date).
    eager_load(
      :detainee,
      :escort,
      :healthcare,
      :offences,
      :risks
    )
  end
end
