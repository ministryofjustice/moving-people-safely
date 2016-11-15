module Forms
  class TextDate < Virtus::Attribute
    def coerce(date)
      return if date.blank?
      DateConverter.convert(date)
    end
  end
end
