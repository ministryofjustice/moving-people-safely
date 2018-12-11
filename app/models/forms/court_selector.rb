# frozen_string_literal: true

module Forms
  class CourtSelector < ActiveModelBase
    attr_accessor :to_type, :crown_court_id, :magistrates_court_id
  end
end
