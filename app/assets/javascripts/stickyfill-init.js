'use strict';

$(function () {

  /**
   * Initialise Stickyfill polyfill for IE9+
   * https://github.com/wilddeer/stickyfill
   */

  if (typeof Stickyfill !== 'undefined') {
    Stickyfill.add($('.side-profile'));
  }
});
