require 'reform/form/coercion'

module Forms
  class Base < Reform::Form
    include Coercion

    TOGGLE_YES = 'yes'
    TOGGLE_NO = 'no'
    DEFAULT_CHOICE = 'unknown'
    TOGGLE_CHOICES = [TOGGLE_YES, TOGGLE_NO, DEFAULT_CHOICE].freeze

    StrictString = Forms::StrictString
    TextDate = Forms::TextDate

    class << self
      def name
        super.demodulize.underscore
      end

      def optional_field(field_name)
        property(field_name, type: StrictString, default: DEFAULT_CHOICE)
        validates field_name,
          inclusion: { in: TOGGLE_CHOICES },
          allow_blank: true
      end

      def optional_details_field(field_name)
        optional_field(field_name)
        property("#{field_name}_details", type: StrictString)
        validates "#{field_name}_details",
          presence: true,
          if: -> { public_send(field_name) == TOGGLE_YES }
      end
    end

    def invalid?
      !valid?
    end

    def toggle_choices
      TOGGLE_CHOICES
    end

    def to_parameter_hash
      @fields.each_with_object({}) do |(k,v), acc|
        if v.is_a? Array
          acc[k] =
            v.map { |x| x.is_a?(Reform::Form) ? x.to_parameter_hash : x }
        elsif v.is_a? Reform::Form
          acc[k] = v.to_parameter_hash
        else
          acc[k] = v
        end
      end
    end
  end
end
