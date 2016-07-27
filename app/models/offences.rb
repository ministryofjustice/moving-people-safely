class Offences < ApplicationRecord
  belongs_to :escort
  has_many :current_offences, dependent: :destroy
  has_many :past_offences, dependent: :destroy

  def all_questions_answered?
    release_date.present? && current_offences.any?
  end
end
