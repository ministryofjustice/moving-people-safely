module RiskAssessment
  class NonAssociationMarkersSection < BaseSection
    def name
      'non_association_markers'
    end

    def questions
      %w[non_association_markers]
    end
    alias mandatory_questions questions
  end
end
