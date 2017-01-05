class Healthcare < ApplicationRecord
  belongs_to :detainee
  include Questionable

  has_many :medications, dependent: :destroy

  def question_fields
    HealthcareWorkflow.mandatory_questions
  end
end
