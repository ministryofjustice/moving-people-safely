'use strict';

var clickableTbodyClass = 'tag-with-href-j';

$('.' + clickableTbodyClass).addClass('clickable');

$(document).on("click", "." + clickableTbodyClass, function(e) {
  if ($(e.target).is("a"))
    return;
  var url = $(this).data("href");
  window.location = url;
});
