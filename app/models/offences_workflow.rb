class OffencesWorkflow < ApplicationRecord
  include Reviewable

  belongs_to :detainee
end
