class Detainee < ApplicationRecord
  belongs_to :escort

  delegate :editable?, :location, to: :escort

  def age
    AgeCalculator.age(date_of_birth)
  end

  def female?
    gender == 'female'
  end

  ETHNICITY_CODES = [
    'A1 - Asian or Asian British Indian',
    'A2 - Asian or Asian British Pakistani',
    'A3 - Asian or Asian British Bangladeshi',
    'A9 - Asian Other',
    'B1 - Black or Black Caribbean',
    'B2 - Black or Black African',
    'B3 - Black Other',
    'M1 - Mixed White & Black Caribbean',
    'M2 - Mixed White & Black African',
    'M3 - Mixed White and Asian',
    'M9 - Mixed Other',
    'NS - Not Stated',
    'O1 - Chinese',
    'O9 - Any Other',
    'W1 - White British',
    'W2 - White Irish',
    'W9 - White Other'
  ].freeze
end
