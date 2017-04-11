class PdfGenerator
  def initialize(move)
    @move = move
  end

  def call
    controller.render_to_string(
      pdf: filename,
      template: 'moves/print/show',
      locals: pdf_locals,
      cover: cover_page,
      header: { content: header_content, spacing: 5 },
      footer: { content: footer_content, spacing: 10 },
      print_media_type: true
    )
  end

  private

  def cover_page
    controller.render_to_string(
      template: 'moves/print/cover',
      locals: pdf_locals
    )
  end

  def pdf_locals
    {
      detainee: detainee_presenter,
      move: move_presenter,
      risk: risk,
      healthcare: healthcare,
      offences: offences_presenter,
      alerts: alerts_presenter
    }
  end

  def filename
    "#{detainee.prison_number}_#{Time.current.strftime('%Y%m%d%H%M')}"
  end

  def move_presenter
    @move_presenter ||= Print::MovePresenter.new(move)
  end

  def detainee_presenter
    @detainee_presenter ||= Print::DetaineePresenter.new(detainee)
  end

  def offences_presenter
    @offences_presenter ||= Print::OffencesPresenter.new(detainee)
  end

  def alerts_presenter
    @alerts_presenter ||= Print::MoveAlertsPresenter.new(move, controller.view_context)
  end

  def controller
    @controller ||= ActionController::Base.new
  end

  def header_content
    controller.render_to_string(template: 'moves/print/header', locals: { detainee: detainee_presenter })
  end

  def footer_content
    controller.render_to_string(template: 'moves/print/footer')
  end

  attr_reader :move

  def detainee
    move.detainee
  end

  private(*delegate(:risk, :healthcare, to: :detainee))
end
