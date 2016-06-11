require 'reform/form/coercion'

module Forms
  class Base < Reform::Form
    include Coercion

    StrictString = Forms::StrictString
    TextDate = Forms::TextDate

    def self.name
      super.demodulize.underscore
    end

    def invalid?
      !valid?
    end
  end
end
