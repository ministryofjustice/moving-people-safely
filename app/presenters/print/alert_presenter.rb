module Print
  class AlertPresenter
    attr_reader :name, :status, :text

    def initialize(name, options)
      @name = name
      @view_context = options.fetch(:view_context)
      @status = options.fetch(:status, :off)
      @title = options[:title]
      @toggle = options[:toggle]
      @text = options[:text]
    end

    def title
      return @title if @title.present?
      h.t("print.alerts.title.#{name}", default: name.to_s.humanize)
    end

    def to_s
      h.content_tag(:div, class: 'alert-wrapper') do
        contents = []
        contents << build_status_content
        contents << build_text_content if text.present?
        h.safe_join(contents)
      end
    end

    private

    attr_reader :view_context, :toggle
    alias h view_context

    def on?
      status == :on
    end

    def build_status_content
      h.content_tag(:div, class: "image #{alert_class}") do
        alert_contents = [h.content_tag(:span, title, class: 'alert-title')]
        alert_contents << toggle_content
        h.safe_join(alert_contents)
      end
    end

    def build_text_content
      h.content_tag(:span, text, class: 'alert-text')
    end

    def toggle_content
      @toggle_content ||= build_toggle_content
    end

    def build_toggle_content
      return h.content_tag(:span, toggle, class: 'alert-toggle') if toggle.present?
      on? ? alert_on_content : alert_off_content
    end

    def alert_class
      on? ? 'alert-on' : 'alert-off'
    end

    def alert_on_content
      h.wicked_pdf_image_tag('ic_red_tick.png', style: 'max-width: 25px; max-height: 25px;')
    end

    def alert_off_content
      h.safe_join [h.tag(:span, class: 'alert-toggle-off'),
                   h.wicked_pdf_image_tag('ic_grey_cross.png', style: 'max-width: 25px; max-height: 25px;'),
                   h.content_tag(:span, 'No', class: 'alert-toggle-off-text')]
    end
  end
end
