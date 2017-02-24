module Print
  module Helpers
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TranslationHelper

    def highlighted_content(content)
      content_tag(:div, content, class: 'strong-text')
    end
    alias strong_title_label highlighted_content

    def title_label(label)
      content_tag(:div, label, class: 'title')
    end
  end
end
