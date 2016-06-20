class Healthcare < ApplicationRecord
  belongs_to :escort
  has_many :medications, dependent: :destroy
end
