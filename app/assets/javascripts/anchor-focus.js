$(document).on('click', '.js-anchor-focus', function(e) {
  var form = $(this).closest('form');
  var currentAction = form.attr('action');
  var multiples = $(this).data('anchor-focus');

  if(multiples) {
    form.attr('action', currentAction + '#' + multiples);
  }
});
