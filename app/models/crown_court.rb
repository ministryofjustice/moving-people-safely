# frozen_string_literal: true

class CrownCourt < Establishment
  default_scope { order('name') }
end
