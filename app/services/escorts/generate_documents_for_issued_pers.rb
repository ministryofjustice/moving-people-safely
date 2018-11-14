module Escorts
  module GenerateDocumentsForIssuedPers
    module_function

    def call(options = {})
      logger = options.fetch(:logger, Rails.logger)
      escorts = Escort.arel_table
      records = Escort.where(escorts[:issued_at].not_eq(nil)).where(document_updated_at: nil)
      logger.info "#{records.count} escorts require a PER document to be generated and stored"
      records.each { |record| DocumentGenerator.new(record, logger: logger).call }
    end

    class DocumentGenerator
      def initialize(escort, options = {})
        @escort = escort
        @logger = options.fetch(:logger, Rails.logger)
      end

      def call
        return if escort.document_updated_at

        logger.info "Generating and storing document for Escort with id #{escort.id}"
        generate_and_store
      end

      private

      attr_reader :escort, :logger

      def generate_and_store
        escort.document = issued_per_document
        escort.save
      ensure
        delete_temp_file
      end

      def issued_per_document
        @issued_per_document ||= generate_per_document
      end

      def generate_per_document
        pdf = PdfGenerator.new(escort).call
        file = Tempfile.new(['per', '.pdf'])
        file.write(pdf.force_encoding('utf-8'))
        file
      end

      def delete_temp_file
        return unless issued_per_document

        issued_per_document.close
        issued_per_document.unlink
      end
    end
  end
end
