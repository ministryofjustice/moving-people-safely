class PdfGenerator
  def initialize(move)
    @move = move
  end

  def call
    ActionController::Base.new.render_to_string(
      pdf: filename,
      template: 'moves/print/show',
      locals: { detainee: detainee_presenter, move: move_presenter, risk: risk, healthcare: healthcare }
    )
  end

  private

  def filename
    "#{detainee.prison_number}_#{Time.current.strftime('%Y%m%d%H%M')}"
  end

  def move_presenter
    @move_presenter ||= Print::MovePresenter.new(move)
  end

  def detainee_presenter
    @detainee_presenter ||= Print::DetaineePresenter.new(detainee)
  end

  attr_reader :move

  def detainee
    move.detainee
  end

  private(*delegate(:risk, :healthcare, to: :detainee))
end
