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
end
