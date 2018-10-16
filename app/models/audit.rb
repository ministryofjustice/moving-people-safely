# frozen_string_literal: true

class Audit < ApplicationRecord
  belongs_to :escort
  belongs_to :user
end
