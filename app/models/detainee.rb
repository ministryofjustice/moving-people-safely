class Detainee < ApplicationRecord
  belongs_to :escort

  delegate :editable?, :location, to: :escort

  def age
    AgeCalculator.age(date_of_birth)
  end

  def female?
    gender == 'female'
  end
end
