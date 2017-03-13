module Print
  class AlertPresenter
    attr_reader :name, :status, :text

    def initialize(name, options)
      @name = name
      @view_context = options.fetch(:view_context)
      @status = options.fetch(:status, :off)
      @title = options[:title]
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

    attr_reader :view_context
    alias h view_context

    def build_status_content
      h.content_tag(:div, class: "image #{alert_class}") do
        alert_contents = [h.content_tag(:span, title, class: 'alert-title')]
        alert_contents << h.wicked_pdf_image_tag('ic_red_tick.png') if status == :on
        h.safe_join(alert_contents)
      end
    end

    def build_text_content
      h.content_tag(:span, text, class: 'alert-text')
    end

    def alert_class
      status == :on ? 'alert-on' : 'alert-off'
    end
  end
end