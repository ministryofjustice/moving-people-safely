class Move < ApplicationRecord
  belongs_to :escort
  has_many :destinations, dependent: :destroy
end
