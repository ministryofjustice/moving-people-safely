class Offence < ApplicationRecord
  has_paper_trail on: :update

  belongs_to :detainee
end
