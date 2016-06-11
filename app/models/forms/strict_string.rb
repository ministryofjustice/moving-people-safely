module Forms
  class StrictString < Virtus::Attribute
    def coerce(value)
      super if value.present?
    end
  end
end
