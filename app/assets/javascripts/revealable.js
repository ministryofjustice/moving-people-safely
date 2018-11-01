// Makes a target revealed/hidden when clicked
'use strict';

var Revealable = {
  init: function () {
    $("[data-hides]").each(function() {
      this.addEventListener("click", Revealable.update)
    });
    $("[data-reveals]").each(function() {
      this.addEventListener("click", Revealable.update)
    });
    this.update();
  },

  update: function () {
    $("[data-hides]").each(function() {
      if(this.checked) {
        $("#"+this.dataset.hides).hide();
      }
    });
    $("[data-reveals]").each(function() {
      if(this.checked) {
        $("#"+this.dataset.reveals).show();
      }
    });
  }
};

Revealable.init();
