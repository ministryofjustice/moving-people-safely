module Summary
  class RiskPresenter < SummaryPresenter
    attr_reader :section_name
    delegate :name, :questions, to: :section

    def self.for(section, risk)
      klass = case section.to_s
              when 'harassments'
                Summary::Risks::HarassmentsSectionPresenter
              when 'sex_offences'
                Summary::Risks::SexOffencesSectionPresenter
              when 'violence'
                Summary::Risks::ViolenceSectionPresenter
              else
                self
              end
      klass.new(risk, section: section)
    end

    def initialize(object, options = {})
      super(object)
      @section_name = options.fetch(:section)
    end

    private

    def section
      @section ||= RiskAssessment.section_for(section_name)
    end
  end
end
