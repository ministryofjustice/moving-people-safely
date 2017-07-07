module Assessments
  class GroupValidator < SimpleDelegator
    VALIDATION_OPTIONS = %i[at_least group message].freeze

    def initialize(object, attr, options = {})
      @attr = attr
      @options = options.with_indifferent_access
      @group = @options.fetch(:group)
      super(object)
    end

    def call
      validate_at_least
    end

    private

    attr_reader :attr, :options, :group

    def present_group_elements
      @present_group_elements ||= group.select(&:present?)
    end

    def validate_at_least
      return unless options.key?(:at_least)
      if present_group_elements.none?
        message = options[:message] || :minimum_one_option
        errors.add(:base, message, attribute: attr_label, options: group_names)
      else
        validate_present_group_elements
      end
    end

    def validate_present_group_elements
      present_group_elements.inject(true) do |valid, elem|
        (elem.valid? && valid).tap do
          elem.errors.each do |attr, message|
            errors.add(attr, message)
          end
        end
      end
    end

    def attr_label
      I18n.t(attr, scope: [:helpers, :label, scope])
    end

    def scope
      group.first.scope
    end

    def group_names
      group.map { |el| I18n.t(el.question_name, scope: [:helpers, :label, el.scope]) }.join(', ')
    end
  end
end
