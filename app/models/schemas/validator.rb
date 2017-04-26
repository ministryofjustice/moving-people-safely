module Schemas
  class Validator
    attr_reader :name, :klass, :options

    def initialize(hash)
      @hash = hash.with_indifferent_access
      @name = @hash.fetch('name')
      @klass = @name.constantize
      @options = @hash['options'] || {}
    end

    def call(object, attr, opts = {})
      klass.new(object, attr, options.merge(opts)).call
    end
  end
end
