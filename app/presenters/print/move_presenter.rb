module Print
  class MovePresenter < SimpleDelegator
    include PresenterHelpers

    def date
      model.date.to_s(:humanized)
    end

    def from
      model.from_establishment&.name
    end

    def not_for_release_text
      return 'Contact the prison to confirm release' if model.not_for_release == 'no'
      return model.not_for_release_reason_details.humanize if model.not_for_release_reason == 'other'
      model.not_for_release_reason.humanize
    end

    private

    def model
      __getobj__
    end
  end
end
