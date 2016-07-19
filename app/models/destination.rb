class Destination < ApplicationRecord
  belongs_to :move

  scope :must_return_to,     -> { where(must_return: 'must_return') }
  scope :must_not_return_to, -> { where(must_return: 'must_not_return') }
end
