module Assessments
  class Question
    attr_reader :name, :mandatory, :section, :dependencies,
      :relevant_answers, :details

    def initialize(data)
      @name = data.fetch(:name)
      @mandatory = data.fetch(:mandatory, false)
      @section = data[:section]
      @dependencies = data.fetch(:dependencies, [])
      @relevant_answers = data.fetch(:relevant_answers, [])
      @details = data.fetch(:details, [])
    end

    def has_dependencies?
      !dependencies.empty?
    end

    def relevant_answer?(answer)
      return false if relevant_answers.empty? || !answer.present?
      return true if relevant_answers == :all
      relevant_answers.include?(answer.downcase)
    end

    def has_details?
      !details.empty?
    end
  end
end
