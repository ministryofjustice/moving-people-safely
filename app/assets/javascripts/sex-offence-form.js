'use-strict';

$.fn.toggle_sex_offence_details_area = function () {
  var $radio_buttons = $("input[name='sex_offences[sex_offence_victim]']:radio");

  if($radio_buttons) {
    var $details_field_wrapper = $('#sex_offences_sex_offence_details').closest('.form-group'),
      toggle_details_field_visibility = function(){
        var under_18_status = $radio_buttons.filter(':checked').val() == 'under_18';
        under_18_status ? $details_field_wrapper.show() : $details_field_wrapper.hide();
      };

    toggle_details_field_visibility();
    $radio_buttons.change(toggle_details_field_visibility);
  }
};

$(document).ready(function(){ $.fn.toggle_sex_offence_details_area() });
