module Print
  class MovePresenter < SimpleDelegator
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TranslationHelper

    def date
      model.date.to_s(:humanized)
    end

    def must_return_to_label
      label_for_destinations(:must_return_to, destinations.must_return_to)
    end

    def must_not_return_to_label
      label_for_destinations(:must_not_return_to, destinations.must_not_return_to)
    end

    def must_return_to
      format_destinations(destinations.must_return_to)
    end

    def must_not_return_to
      format_destinations(destinations.must_not_return_to)
    end

    private

    def label_for_destinations(attr, destinations)
      label = t(attr, scope: [:print, :label, :move])
      return title_label(label) if destinations.empty?
      strong_title_label(label)
    end

    def strong_title_label(label)
      content_tag(:div, label, class: 'strong-text')
    end

    def title_label(label)
      content_tag(:div, label, class: 'title')
    end

    def format_destinations(destinations)
      return 'None' if destinations.empty?
      safe_join(destinations.map do |destination|
        array = [destination.establishment]
        array << ": #{destination.reasons}" if destination.reasons.present?
        strong_title_label(array.join(''))
      end)
    end

    def model
      __getobj__
    end
  end
end
