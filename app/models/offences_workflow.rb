class OffencesWorkflow < ApplicationRecord
  include Reviewable

  belongs_to :escort

  delegate :editable?, to: :escort
end
