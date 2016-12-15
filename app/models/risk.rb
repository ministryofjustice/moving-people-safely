class Risk < ApplicationRecord
  belongs_to :detainee
  include Questionable

  def question_fields
    RiskWorkflow.mandatory_questions
  end
end
