class PdfGenerator
  def initialize(escort)
    @escort = escort
  end

  def call
    ApplicationController.render(
      pdf: filename,
      template: 'escorts/print/show',
      layout: false,
      locals: { escort: escort },
      cover: cover_page,
      header: { content: header_content, spacing: 5 },
      footer: { content: footer_content, spacing: 10 },
      print_media_type: true
    )
  end

  private

  attr_reader :escort

  def cover_page
    ApplicationController.render(
      template: 'escorts/print/cover',
      layout: false,
      locals: { escort: escort }
    )
  end

  def filename
    "#{escort.number}_#{Time.current.strftime('%Y%m%d%H%M')}"
  end

  def header_content
    ApplicationController.render(
      template: 'escorts/print/header',
      layout: false,
      locals: { escort: escort }
    )
  end

  def footer_content
    ApplicationController.render(template: 'escorts/print/footer', layout: false)
  end
end
