class OffencesWorkflow < ApplicationRecord
  include Reviewable

  DELEGATED_METHODS = %i[status needs_review? needs_review! incomplete? unconfirmed? confirmed? confirm!].freeze

  belongs_to :detainee
end
