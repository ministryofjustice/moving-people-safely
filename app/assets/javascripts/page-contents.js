// Sticky page contents
'use strict';

var PageContents = {
  init: function () {
    this.$anchorContainer = $('.page_contents_list');
    if (this.$anchorContainer.length !== 1) {
      return;
    }

    this.$window = $(window);
    this.$anchors = $('.page_contents_list__items a');
    this.$headings = this.$anchors.map(function () {
      return $($(this).attr('href'));
    });
    this.$headingContainerParent = $(this.$headings[0]).parent();

    this.update();
    this.$window.on('scroll resize', $.proxy(this.update, this));
  },

  update: function () {
    this.$anchors.removeClass('active');

    var containerTop = this.$headingContainerParent.offset().top;
    var scrollOffset = this.$window.scrollTop() - containerTop;
    var index = -1;
    this.$headings.each(function (i) {
      var $heading = $(this);
      if ($heading.offset().top + $heading.height() - containerTop > scrollOffset) {
        index = i;
        return false;
      }
    });
    $(this.$anchors.get(index)).addClass('active');
  }
};

PageContents.init();
