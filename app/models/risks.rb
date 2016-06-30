class Risks < ApplicationRecord
  belongs_to :escort
  has_many :non_association_markers, dependent: :destroy
end
