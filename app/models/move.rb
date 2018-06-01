class Move < ApplicationRecord
  belongs_to :escort
  belongs_to :from_establishment, class_name: 'Establishment'
end
