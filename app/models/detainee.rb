class Detainee < ApplicationRecord
  belongs_to :escort

  def age
    AgeCalculator.age(date_of_birth)
  end
end
