describe("AnchorFocus", function() {
  it("changes the form action", function() {
    loadFixtures("anchor_focus.html");

    var form = $('.js-anchor-focus').closest('form');

    // we dont want to actually submit the form to the fake endpoint
    form.submit(function(e) { return false });

    expect(form.attr('action')).toEqual("http://localhost:3000/some-action");

    $('.js-anchor-focus').click()

    expect(form.attr('action')).toEqual("http://localhost:3000/some-action#foo");
  });
});
