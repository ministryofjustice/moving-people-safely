$(document).on('click', '.js-anchor-focus', function(e) {
  var form = $(this).closest('form'),
    currentAction = form.attr('action'),
    multiples = $(this).data('anchor-focus');
  form.attr('action', currentAction + '#' + multiples);
});
