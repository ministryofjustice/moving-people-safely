namespace :escorts do
  namespace :unissued do
    desc '(soft) deletes unissued escorts past their move date'
    task delete: :environment do
      Escorts::DeleteHistoricUnissued.call(logger: Logger.new(STDOUT))
    end
  end
end
