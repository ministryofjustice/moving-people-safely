# frozen_string_literal: true

require 'active_support/concern'

module Questionable
  extend ActiveSupport::Concern

  SECTIONS = YAML.load_file(Rails.root.join('config', 'sections.yml'))

  included do
    def self.sections(location)
      SECTIONS[location][to_s.downcase].keys
    end

    def self.mandatory_questions(location)
      SECTIONS[location][to_s.downcase].values.flatten
    end
  end

  def all_questions_answered?
    self.class.mandatory_questions(location).all? do |question|
      public_send(question).present?
    end
  end

  def question_relevant?(question)
    relevant_questions.include? question
  end

  def section_relevant?(questions)
    questions.any? { |question| relevant_questions.include? question }
  end
end
