module Questionable
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module ClassMethods
    def act_as_assessment(name)
      @schema = Schemas::Assessment.new(ASSESSMENTS_SCHEMA[name.to_s])
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

    def no_questions_answered?
      mandatory_questions.none?(&:answered?)
    end

    def total_questions_with_relevant_answer
      mandatory_questions.count do |question|
        question.answered? && question.relevant_answer?
      end
    end

    def total_questions_without_relevance
      mandatory_questions.count do |question|
        question.answered? && !question.relevant_answer?
      end
    end

    def total_questions_not_answered
      mandatory_questions.count { |question| !question.answered? }
    end
  end
end
