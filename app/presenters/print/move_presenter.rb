module Print
  class MovePresenter < SimpleDelegator
    include PresenterHelpers

    def date
      model.date.to_s(:humanized)
    end

    private

    def model
      __getobj__
    end
  end
end
