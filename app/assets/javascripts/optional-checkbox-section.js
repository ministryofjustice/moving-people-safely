'use strict';

$(function () {

  /**
   * Links visibility of an optional section to the selection within a specified set of controls
   * @param {jQuery wrapped input} $input - A radio button.
   */

  var manageStateOfOptionalCheckboxSection = function ($input, $optional_checkbox_section_wrapper) {
    var id = $input.attr('id');
    switch (true) {
      case /_prison_staff$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_risk_to_females$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_escort_or_court_staff$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_healthcare_staff$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_other_detainees$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_homophobic$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_racist$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_public_offence_related$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      case /_police$/.test(id):
        if ($input.is(":checked")) {
          $optional_checkbox_section_wrapper.show();
        } else {
          $optional_checkbox_section_wrapper.hide();
        }
        break;
      default:
        $optional_checkbox_section_wrapper.hide();
    }
  };

  $.fn.optional_checkbox_section = function (options) {

    var settings = $.extend({}, $.fn.optional_checkbox_section.defaults, options);

    return this.each(function () {
      var $this = $(this),
        $controls = $(settings.controls_for_optional_checkbox_section, $this),
        $checked_item_at_load = $controls.find(':checked'),
        $optional_checkbox_section_wrapper = $(settings.optional_checkbox_section_wrapper, $this),
        $clear_selection_control = $controls.find('label[for$="_unknown"]');

      // Initialization
      manageStateOfOptionalCheckboxSection($checked_item_at_load, $optional_checkbox_section_wrapper);

      // Event management
      $controls.on('change', function (e) {
        var $input = $(e.target);
        manageStateOfOptionalCheckboxSection($input, $optional_checkbox_section_wrapper);
      });

    })
  };

  $.fn.optional_checkbox_section.defaults = {
    controls_for_optional_checkbox_section: '.controls-optional-checkbox-section',
    optional_checkbox_section_wrapper: '.optional-checkbox-section-wrapper'
  };

  $('.js-checkbox-show-hide').optional_checkbox_section();
});
