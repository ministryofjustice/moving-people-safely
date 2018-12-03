# frozen_string_literal: true

class MagistratesCourt < Establishment
  default_scope { order('name') }
end
