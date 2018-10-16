# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do
    def audit(escort, user, action)
      return unless escort.issued?
      Audit.create(escort: escort, user: user, action: action)
    end
  end
end
