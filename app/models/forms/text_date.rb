module Forms
  class TextDate < Virtus::Attribute
    def coerce(date)
      DateConverter.convert(date)
    end
  end
end
