class Offences < ApplicationRecord
  belongs_to :detainee
  has_many :current_offences, dependent: :destroy
  has_many :past_offences, dependent: :destroy

  def all_questions_answered?
    current_offences.any?
  end
end
