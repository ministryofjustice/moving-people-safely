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
        var multipleWrapper = $this.closest('.multiple-wrapper');
        var multiplesParent = multipleWrapper.parent();
        multipleWrapper.addClass('mps-hide');
        var removeLinks = multiplesParent.find('.multiple-wrapper:not(.mps-hide) .remove-link');
        if(removeLinks.length == 1){
          removeLinks.each(function(){
            $(this).hide();
          });
        }
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
