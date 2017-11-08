module Questionable
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module ClassMethods
    def act_as_assessment(name, options = {})
      @schema = Schemas::Assessment.new(ASSESSMENTS_SCHEMA[name.to_s])
      @complex_attributes = options.fetch(:complex_attributes, [])
      define_complex_attributes_methods
    end

    def schema
      @schema
    end

    def section_names
      schema.sections.map(&:name)
    end

    def has_intro?
      schema.has_intro?
    end

    def complex_attributes
      @complex_attributes
    end

    def define_complex_attributes_methods
      complex_attributes.each do |complex_attribute|
        serialize complex_attribute, Array

        define_method complex_attribute do
          variable_name = "@#{complex_attribute}"
          return instance_variable_get(variable_name) if instance_variable_defined?(variable_name)
          read_attribute(complex_attribute).map do |attrs|
            ComplexAttribute.new(attrs)
          end.tap { |array| instance_variable_set(variable_name, array) }
        end

        define_method "#{complex_attribute}_attributes=" do |attributes|
          indexes_to_be_deleted = []
          attributes.each do |attrs_index, attrs|
            index = attrs_index.to_i
            new_complex = ComplexAttribute.new(attrs)

            existent_complex = send(complex_attribute)[index]

            if existent_complex
              if new_complex.to_be_deleted?
                indexes_to_be_deleted << index
              elsif new_complex != existent_complex
                send(complex_attribute)[index] = new_complex
              end
            else
              unless new_complex.to_be_deleted?
                new_complex.id = SecureRandom.uuid
                send(complex_attribute) << new_complex
              end
            end
          end
          indexes_to_be_deleted.each { |index| send(complex_attribute).delete_at(index) }
          write_attribute(complex_attribute, send(complex_attribute).map(&:to_h))
        end
      end
    end
  end

  module InstanceMethods
    def schema
      self.class.schema
    end

    def sections
      @sections ||= schema.sections.map do |section_schema|
        Assessments::Section.new(self, section_schema)
      end
    end

    def has_intro?
      self.class.has_intro?
    end

    def mandatory_questions
      @mandatory_questions ||= sections.flat_map(&:mandatory_questions)
    end

    def all_questions_answered?
      mandatory_questions.all?(&:answered?)
    end
  end
end
