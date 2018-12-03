# frozen_string_literal: true

class PoliceCustody < Establishment
  default_scope { order('name') }
end
