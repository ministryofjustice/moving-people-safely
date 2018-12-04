# frozen_string_literal: true

class EscortIssuer
  EscortNotEditableError = Class.new(StandardError)
  EscortNotReadyForIssueError = Class.new(StandardError)
  EscortNotApprovedError = Class.new(StandardError)

  def self.call(escort)
    new(escort).call
  end

  def initialize(escort)
    @escort = escort
  end

  def call
    raise EscortNotEditableError if !escort.editable? && escort.from_prison?
    raise EscortNotApprovedError if !escort.approved? && escort.from_police?
    raise EscortNotReadyForIssueError unless escort.completed?

    issue_per
  end

  private

  attr_reader :escort

  def issue_per
    escort.transaction do
      escort.document = issued_per_document
      escort.issue!
    end
  ensure
    delete_temp_file
  end

  def issued_per_document
    @issued_per_document ||= generate_per_document
  end

  def generate_per_document
    pdf = PdfGenerator.new(escort).call
    file = Tempfile.new(['per-', '.pdf'])
    file.write(pdf.force_encoding('utf-8'))
    file
  end

  def delete_temp_file
    return unless issued_per_document

    issued_per_document.close
    issued_per_document.unlink
  end
end
