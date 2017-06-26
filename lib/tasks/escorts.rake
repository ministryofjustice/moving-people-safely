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
end
