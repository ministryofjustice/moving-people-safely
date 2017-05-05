module Assessments
  class DateValidator < SimpleDelegator
    VALIDATION_OPTIONS = %i[format not_in_the_past not_in_the_future message].freeze

    def initialize(object, attr, options = {})
      @attr = attr
      @options = options.with_indifferent_access
      super(object)
    end

    def call
      ::DateValidator.new(validation_options.merge(attributes: attr)).validate(self)
    end

    private

    attr_reader :attr, :options

    def validation_options
      options.slice(*VALIDATION_OPTIONS)
    end
  end
end
