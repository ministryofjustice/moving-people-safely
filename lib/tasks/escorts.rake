# frozen_string_literal: true

require_relative '../audit_report'

namespace :escorts do
  namespace :unissued do
    desc '(soft) deletes unissued escorts past their move date'
    task delete: :environment do
      Escorts::DeleteHistoricUnissued.call(logger: Logger.new(STDOUT))
    end
  end

  namespace :issued do
    desc 'generate issued PER document and store it'
    task generate_document: :environment do
      Escorts::GenerateDocumentsForIssuedPers.call(logger: Logger.new(STDOUT))
    end
  end

  desc 'CSV audit report on a PER (needs ID param)'
  task audit: :environment do
    AuditReport.new(ENV['ID']).call
  end
end
