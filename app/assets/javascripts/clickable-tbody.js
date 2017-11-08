$(document).on("click", ".tag-with-href-j", function(e) {
  if ($(e.target).is("a"))
    return;
  var url = $(this).data("href");
  window.location = url;
});
