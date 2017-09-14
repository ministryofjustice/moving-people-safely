class OffencesWorkflow < ApplicationRecord
  include Reviewable

  belongs_to :escort
end
