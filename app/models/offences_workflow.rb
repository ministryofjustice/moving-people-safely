# frozen_string_literal: true

class OffencesWorkflow < ApplicationRecord
  include Reviewable

  belongs_to :escort

  delegate :editable?, to: :escort
end
