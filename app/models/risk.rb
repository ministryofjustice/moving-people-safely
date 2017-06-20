class Risk < ApplicationRecord
  include Questionable
  include Reviewable
  act_as_assessment :risk, complex_attributes: %i[must_not_return_details]

  belongs_to :escort
end
