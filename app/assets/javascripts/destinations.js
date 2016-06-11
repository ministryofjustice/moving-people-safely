'use strict';

$(function () {

  /**
   * Links visibility of an optional section to the
   * @param {jQuery wrapped input} $input - A radio button.
   * @param {jQuery wrapped div} $optional_section - The optional section that is to be shown/hidden.
   */

  var manageStateOfOptionalSection = function ($input, $optional_section_wrapper) {
    switch ($input.attr('id')) {
      case 'move_information_has_destinations_yes':
        $optional_section_wrapper.show();
        break;
      case 'move_information_has_destinations_no':
        $optional_section_wrapper.hide();
        break;
      case 'move_information_has_destinations_clear_selection':
        $optional_section_wrapper.hide();
        break;
      default:
        $optional_section_wrapper.hide();
    }
  };

  $.fn.destinations = function (options) {

    var settings = $.extend({}, $.fn.destinations.defaults, options);

    return this.each(function () {
      var $this = $(this),
        $controls = $(settings.controls_for_optional_section, $this),
        $checked_item_at_load = $controls.find(':checked'),
        $optional_section = $(settings.optional_section, $this),
        $optional_section_wrapper = $(settings.optional_section_wrapper, $this);

      // Initialization
      manageStateOfOptionalSection($checked_item_at_load, $optional_section_wrapper);

      // Event management
      $controls.on('change', function (e) {
        var $input = $(e.target);
        manageStateOfOptionalSection($input, $optional_section_wrapper);
      });

      $optional_section.on('change', function (e) {
        var $this = $(this),
          $changed_element = $(e.target);
        if(/move_information_destinations_attributes_\d+__delete/.test($changed_element.attr('id'))) {
          $this.hide();
        } else {
          $this.show();
        }
      });

    })
  };

  $.fn.destinations.defaults = {
    controls_for_optional_section: '.controls-optional-section',
    optional_section_wrapper: '.optional-section-wrapper',
    optional_section: '.optional-section'
  };

  $('.js_destinations').destinations();
});
