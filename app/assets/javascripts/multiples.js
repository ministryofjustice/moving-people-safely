'use strict';

$(function () {

  /**
   * Hides selected elements when an element with id ending in one or
   * more digits followed by '_delete' triggers a 'change' event
   */

  $.fn.multiples = function () {

    return this.each(function () {
      var $this = $(this);

      var input = $this.find('.remove-link input:checkbox')

      // Hide multiple from when 'delete' radio state changes
      input.on('change', function () {
        $this.closest('.multiple-wrapper').addClass('mps-hide');
      })
    })
  };

  $(document).ready(function() {
    $('.multiple-wrapper .remove-link input:checkbox').click(function () {
      // Cause the change() event
      // to be fired in IE8 et. al.
      // http://www.ridgesolutions.ie/index.php/2011/03/02/ie8-chage-jquery-event-not-firing/
      this.blur();
      this.focus();
    });
  });

  $('.multiple-wrapper').multiples();
});
