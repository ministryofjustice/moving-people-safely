# frozen_string_literal: true

class ImmigrationRemovalCentre < Establishment
  default_scope { order('name') }
end
