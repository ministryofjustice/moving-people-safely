module Summary
  class EscortSectionStatusPresenter
    include PresenterHelpers

    def initialize(section, name:)
      @section = section
      @name = name
      @status = set_status
    end

    def title
      return default_title if escort.issued? || !status.present?
      t("summary.status.#{status}.title")
    end

    def label
      return unless status
      t("summary.status.#{status}.label")
    end

    def label_status
      {
        'incomplete' => 'incomplete',
        'needs_review' => 'incomplete',
        'confirmed' => 'complete'
      }[status]
    end

    def has_status?
      status.present?
    end

    private

    attr_reader :section, :name, :status
    delegate :escort, to: :section

    def default_title
      t("summary.#{name}.title")
    end

    def set_status
      return unless %w[incomplete needs_review confirmed].include?(section.status)
      section.status
    end
  end
end
