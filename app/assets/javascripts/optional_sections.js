'use strict';

$(function () {

  /**
   * Links visibility of an optional section to the selection within a specified set of controls
   * @param {jQuery wrapped input} $input - A radio button.
   */

  var manageStateOfOptionalSection = function ($input, $optional_section_wrapper) {
    var id = $input.attr('id');
    switch (true) {
      case /_yes$/.test(id):
        $optional_section_wrapper.show();
        break;
      case /_no$/.test(id):
        $optional_section_wrapper.hide();
        break;
      case /_clear_selection$/.test(id):
        $optional_section_wrapper.hide();
        break;
      default:
        $optional_section_wrapper.hide();
    }
  };

  $.fn.optional_section = function (options) {

    var settings = $.extend({}, $.fn.optional_section.defaults, options);

    return this.each(function () {
      var $this = $(this),
        $controls = $(settings.controls_for_optional_section, $this),
        $checked_item_at_load = $controls.find(':checked'),
        $optional_section_wrapper = $(settings.optional_section_wrapper, $this);

      // Initialization
      manageStateOfOptionalSection($checked_item_at_load, $optional_section_wrapper);

      // Event management
      $controls.on('change', function (e) {
        var $input = $(e.target);
        manageStateOfOptionalSection($input, $optional_section_wrapper);
      });

    })
  };

  $.fn.optional_section.defaults = {
    controls_for_optional_section: '.controls-optional-section',
    optional_section_wrapper: '.optional-section-wrapper'
  };

  $('.js_destinations').optional_section();
});
