# frozen_string_literal: true

class YouthSecureEstate < Establishment
  default_scope { order('name') }
end
