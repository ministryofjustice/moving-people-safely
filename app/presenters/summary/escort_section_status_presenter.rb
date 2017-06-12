module Summary
  class EscortSectionStatusPresenter
    include PresenterHelpers

    delegate :needs_review?, to: :section

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

    def last_updated_info
      start_time = twig&.send(name)&.reviewed_at || section.updated_at
      time_difference = time_diff(start_time.utc, Time.now.utc)
      t('summary.alerts.last_updated_info', time_difference: time_difference)
    end

    def up_to_date_warning
      t('summary.alerts.up_to_date_warning')
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

    def twig
      escort.twig
    end
  end
end
