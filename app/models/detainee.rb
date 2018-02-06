class Detainee < ApplicationRecord
  has_paper_trail on: :update, skip: %i[image image_filename]

  belongs_to :escort
  has_many :offences, dependent: :destroy

  def age
    AgeCalculator.age(date_of_birth)
  end
end
