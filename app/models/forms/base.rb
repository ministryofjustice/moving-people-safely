require 'reform/form/coercion'

module Forms
  class Base < Reform::Form
    include Coercion

    TOGGLE_CHOICES = %w[ yes no unknown ]

    StrictString = Forms::StrictString
    TextDate = Forms::TextDate

    def self.name
      super.demodulize.underscore
    end

    def invalid?
      !valid?
    end

    def toggle_choices
      TOGGLE_CHOICES
    end
  end
end
