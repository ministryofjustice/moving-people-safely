class MovePresenter < SimpleDelegator
  include ActionView::Helpers::OutputSafetyHelper

  def humanized_date
    date && date.to_s(:humanized)
  end

  def from
    from_establishment&.name
  end
end
