class Escort < ApplicationRecord
  has_one :detainee, dependent: :destroy
end
