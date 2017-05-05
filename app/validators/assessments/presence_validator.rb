module Assessments
  class PresenceValidator < SimpleDelegator
    VALIDATION_OPTIONS = %i[allow_nil allow_blank message].freeze

    def initialize(object, attr, options = {})
      @attr = attr
      @options = options.with_indifferent_access
      super(object)
    end

    def call
      validates_presence_of attr, validation_options
    end

    private

    attr_reader :attr, :options

    def validation_options
      options.slice(*VALIDATION_OPTIONS)
    end
  end
end
