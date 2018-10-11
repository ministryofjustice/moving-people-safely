module PrintHelper
  def content_or_dash(value)
    value.present? ? value : '&ndash;'.html_safe
  end
end
