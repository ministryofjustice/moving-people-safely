describe("No script", function() {
  beforeEach(function(){
    loadFixtures("no_script.html");
  });

  it("hides any content wrapped under a no-script class", function(){
    expect($('.wrapped-content').is(':visible')).toBe(false);
  });

  it("does not remove the no-script class from the elements containing it", function(){
    expect($('.no-script').size()).toBeGreaterThan(0);
  });

  it("does not enable any disabled elements wrapped under the no-script class", function(){
    expect($('.no-script-disabled').is(':disabled')).toBe(true);
  });

  describe("when no script restrictions are removed", function() {
    beforeEach(function(){
      $.fn.removeNoScriptRestrictions();
    });

    it("shows any content wrapped under a no-script class", function(){
      expect($('.wrapped-content').is(':visible')).toBe(true);
    });

    it("removes the no-script class from all elements containing it", function(){
      expect($('.no-script').size()).toBe(0);
    });

    it("enables any disabled elements wrapped under the no-script class", function(){
      expect($('.no-script-disabled').is(':disabled')).toBe(false);
    });
  });
});
