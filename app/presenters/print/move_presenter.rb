module Print
  class MovePresenter < SimpleDelegator
    include PresenterHelpers

    def date
      model.date.to_s(:humanized)
    end

    def from
      model.from_establishment&.name
    end

    private

    def model
      __getobj__
    end
  end
end
