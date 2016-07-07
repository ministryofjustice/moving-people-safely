'use-strict';

$(function () {
  $.fn.checkbox_with_textarea = function () {
    var controls = '.controls-optional-checkbox-section',
      optional_section_wrapper = '.optional-checkbox-section-wrapper',

      set_visibility = function (visible, $wrapper) {
        if(visible) {
          $wrapper.show();
        } else {
          $wrapper.hide();
        }
      };

    return this.each(function () {
      var $this = $(this),
        $controls_wrapper = $(controls, $this),
        $control = $controls_wrapper.find('input:checkbox'),
        $wrapper = $(optional_section_wrapper, $this);

      // initialize state
      set_visibility($control.is(':checked'), $wrapper);

      $control.on('change', function (e) {
        var status = $(e.target).is(':checked');
        set_visibility(status, $wrapper);
      });
    });
  };


  $('.js-checkbox-show-hide').checkbox_with_textarea()
});
