module Page
  class SelectPoliceStation < Base
    def select_station(name)
      select name, from: 'Police custody suite'
      save_and_continue
    end
  end
end
