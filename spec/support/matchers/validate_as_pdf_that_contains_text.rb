RSpec::Matchers.define :validate_as_pdf_that_contains_text do |file_name|
  match do |pdf_content|
    @pdf_text = extract_pdf_text(pdf_content)
    @expected_text = File.open(expected_text_file_path(file_name)).read

    @pdf_text == @expected_text
  end

  failure_message do
    <<~TXT
      expected pdf to contain the same text as in: #{file_name}

      the following snippet will show the diff:

      #{text_difference}
    TXT
  end

  description do
    "validate pdf contains the same text as in: #{file_name}"
  end

  private

  def extract_pdf_text(pdf_content)
    file = Tempfile.new('tempfile').tap do |f|
      f.binmode
      f << pdf_content
    end

    PDF::Reader.new(file).pages.flat_map(&:text).join
  end

  def expected_text_file_path(file_name)
    Rails.root.join("spec", "support", "fixtures", file_name)
  end

  def text_difference
    Diffy::Diff.new(@pdf_text, @expected_text, context: 1).to_s(:text)
  end
end
