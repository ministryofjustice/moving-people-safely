'use-strict';

$.fn.datepicker.defaults.format = "dd/mm/yyyy";
$.fn.datepicker.defaults.autoclose = true;
$.fn.datepicker.defaults.todayHighlight = true;
$.fn.datepicker.defaults.keyboardNavigation = false;
$.fn.datepicker.defaults.maxViewMode = 0;

$(function () {
  var updateRadioDateSelectors = function(dateValue) {
    $('.radio-date-selector').each(function() {
      var $selector = $(this);
      if($selector.val() == dateValue)
        $selector.prop('checked', true);
      else
        $selector.prop('checked', false);
    });
  };

  $.fn.radio_date_selectors = function () {
    return this.each(function () {
      var $selector = $(this);
      $selector.on('change', function (e) {
        var $input = $(e.target);
        $('.date-field').datepicker('update', $input.val());
      });
    });
  };

  $.fn.date_field_updator = function () {
    return this.each(function () {
      var $field = $(this);
      $field.on('change', function (e) {
        var $input = $(e.target);
        updateRadioDateSelectors($input.val());
      });
    });
  };

  $('.radio-date-selector').radio_date_selectors();
  $('.date-field').date_field_updator();
});
