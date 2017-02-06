class MovePresenter < SimpleDelegator
  include ActionView::Helpers::OutputSafetyHelper

  def humanized_date
    date && date.to_s(:humanized)
  end

  def must_return_to
    format_destinations(destinations.must_return_to)
  end

  def must_not_return_to
    format_destinations(destinations.must_not_return_to)
  end

  private

  def format_destinations(destinations)
    return 'None' if destinations.empty?
    safe_join(destinations.map do |destination|
      array = [destination.establishment]
      array << "(#{destination.reasons})" if destination.reasons.present?
      array.join(' ')
    end, '<br />'.html_safe)
  end
end
