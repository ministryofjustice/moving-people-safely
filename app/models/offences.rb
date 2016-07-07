class Offences < ApplicationRecord
  belongs_to :escort
  has_many :current_offences, dependent: :destroy
end
