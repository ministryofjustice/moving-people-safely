'use strict';

$(function () {

  /**
   * Links visibility of an optional section to the selection within a specified set of controls
   * @param {jQuery wrapped input} $input - A radio button.
   */

  var manageStateOfOptionalSection = function ($input, $optional_section_wrapper, $clear_selection_control) {
    var id = $input.attr('id');
    switch (true) {
      case /_yes$/.test(id):
        show($optional_section_wrapper);
        show($clear_selection_control);
        break;
      case /_high$/.test(id):
        show($optional_section_wrapper);
        show($clear_selection_control);
        break;
      case /_standard$/.test(id):
        hide($optional_section_wrapper);
        show($clear_selection_control);
        break;
      case /_no$/.test(id):
        hide($optional_section_wrapper);
        show($clear_selection_control);
        break;
      case /_unknown$/.test(id):
        hide($optional_section_wrapper);
        hide($clear_selection_control);
        break;
      case /_other$/.test(id):
        show($optional_section_wrapper);
        break;
      default:
        hide($optional_section_wrapper);
        hide($clear_selection_control);
    }
  };

  var show = function($el) {
    $el.removeClass('mps-hide');
  }

  var hide = function($el) {
    $el.addClass('mps-hide');
  }

  $.fn.optional_section = function (options) {

    var settings = $.extend({}, $.fn.optional_section.defaults, options);

    return this.each(function () {
      var $this = $(this),
        $controls = $(settings.controls_for_optional_section, $this),
        $checked_item_at_load = $controls.find(':checked'),
        $optional_section_wrapper = $(settings.optional_section_wrapper, $this),
        $clear_selection_control = $controls.find('label[for$="_unknown"]');

      // Initialization
      manageStateOfOptionalSection($checked_item_at_load, $optional_section_wrapper, $clear_selection_control);

      // Event management
      $controls.on('change', function (e) {
        var $input = $(e.target);
        manageStateOfOptionalSection($input, $optional_section_wrapper, $clear_selection_control);
      });

    })
  };

  $.fn.optional_section.defaults = {
    controls_for_optional_section: '.controls-optional-section',
    optional_section_wrapper: '.optional-section-wrapper'
  };

  $('.js-show-hide').optional_section();
});
