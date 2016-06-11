class HomepageCell < Cell::ViewModel
  private

  def form
    model
  end

  delegate :errors, to: :form

  def form_styles
    %w[ search_input_wrapper ].tap { |s| s << 'error' if errors.any? }.join(' ')
  end

  def search_error_message
    content_tag(:p, errors.full_messages.first) if errors.any?
  end

  def search_results
    search = SearchState.new(form)

    if search.not_yet_performed_or_invalid?
      return
    elsif search.no_result?
      cell(NoResultsCell, form.prison_number)
    end
  end

  SearchState = Struct.new(:form) do
    def not_yet_performed_or_invalid?
      form.prison_number.blank? || form.invalid?
    end

    def result?
      form.escort.present?
    end

    def no_result?
      !result?
    end
  end
end
