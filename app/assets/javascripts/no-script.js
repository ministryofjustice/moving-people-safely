'use-strict';

$(function() {
  $.fn.removeNoScriptRestrictions = function() {
    $('.no-script').each(function() {
      $(this).removeClass('no-script');
      $(this).find('input:disabled').each(function() {
        $(this).prop('disabled', false);
      });
    });
  };

  $.fn.removeNoScriptRestrictions();
});
