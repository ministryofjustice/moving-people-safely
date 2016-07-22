class DetaineeSearchResultsSection < SitePrism::Section
  element :profile_link, 'td:n-th-child(0) a'
  element :detainee_name, 'td:nth-child(1)'
  element :dob, 'td:nth-child(2)'
  element :destination, 'td:nth-child(3)'
  element :move_date, 'td:nth-child(4)'
end

class DatePickerSection < SitePrism::Section
  element :date_field, 'input[type="text"]'
  element :date_submit_button, 'input[value="Go"]'
  element :back_a_day_button, 'input[value="<"]'
  element :today_button, 'input[value="today"]'
  element :forward_a_day_button, 'input[value=">"]'
end

class DashboardPage < SitePrism::Page
  set_url '/'
  sections :search_results, DetaineeSearchResultsSection, '.search_module table tr'

  section :date_picker, DatePickerSection, '.date-picker'

  element :search_field, '.search_module input#search_prison_number'
  element :search_button, '.search_module input.search_button'
  element :add_new_move_button, 'input[type="submit"][value="Add new move"]'
  element :create_new_profile, 'input[type="submit"][value="Create new profile"]'

  def search(prison_number)
    search_field.set prison_number
    search_button.click
  end
end
