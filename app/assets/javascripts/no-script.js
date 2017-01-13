'use-strict';

$(function () {
  $('.no-script').each(function() {
    $(this).removeClass('no-script');
    $(this).find('input:disabled').each(function() {
      $(this).prop('disabled', false);
    });
  });
});
