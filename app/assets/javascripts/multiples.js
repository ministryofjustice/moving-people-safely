'use strict';

$(function () {

  /**
   * Hides selected elements when an element with id ending in one or
   * more digits followed by '_delete' triggers a 'change' event
   */

  $.fn.multiples = function () {

    return this.each(function () {
      var $this = $(this);

      $this.on('change', function (e) {
        var changed_element_id = $(e.target).attr('id');
        if (/move_information_destinations_attributes_\d+__delete/.test(changed_element_id)) {
          $this.hide();
        }
      })
    })
  };

  $('.optional-section').multiples();

});