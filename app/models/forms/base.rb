require 'reform/form/coercion'

module Forms
  class Base < Reform::Form
    include Coercion

    def invalid?
      !valid?
    end
  end
end
