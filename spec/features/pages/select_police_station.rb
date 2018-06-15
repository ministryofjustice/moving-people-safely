module Page
  class SelectPoliceStation < Base
    def select_station(name)
      select name, from: 'police_custody'
      click_button 'Save and continue'
    end
  end
end
