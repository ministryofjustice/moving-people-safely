module Considerations
  class CollectionProxy
    include ActiveModel::Model
    include ActiveModel::Conversion
    extend ActiveModel::Translation # why?

    def initialize(name, models)
      @models = models
      @name = name.to_s
      setup
    end

    attr_reader :name, :models

    def questions_answered
      @models.count(&:id)
    end

    def questions_unanswered
      @models.count - questions_answered
    end

    def all_questions_answered?
      @models.count == questions_answered
    end

    def no_questions_answered?
      questions_answered.zero?
    end

    def model_name
      ActiveModel::Name.new(@name, nil, @name)
    end

    def assign_attributes(params)
      # params = { dependencies: { option: 'no', details: ''}, medications: { option: 'no', collection: [] }}
      params.each do |model, params|
        send(model).properties = params if respond_to? model
      end
    end

    def to_params
      models.each_with_object({}) do |model, params|
        params[model.name] = model.properties
      end
    end

    def prepopulate
      models.each(&:prepopulate)
    end

    def valid?(*)
      models.all?(&:valid?)
    end
    alias_method :validate, :valid?

    def errors
      models.each_with_object(ActiveModel::Errors.new(self)) do |model, error_obj|
        next if model.errors.none?

        model.errors.messages.each do |method_name, msgs|
          namespaced_name = "#{model.name}.#{method_name}"
          msgs.each { |msg| error_obj.add(namespaced_name, msg) }
        end
      end
    end

    def save
      save!
    rescue
      false
    end

    def save!
      ActiveRecord::Base.transaction { models.each(&:save!) }
    end

    def to_s
      name
    end

    private

    def setup
      models.each do |m|
        class_eval do
          define_method(m.name) do
            m
          end
        end
      end
    end
  end
end
