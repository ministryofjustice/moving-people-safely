'use strict';

$(function () {
    function selectVisibility() {
        var toggler_id = $(this).attr('id');
        var this_concertina = $(this).closest('.radio-concertina');

        // Hide all toggles
        this_concertina.find('[data-toggled-by]').hide();

        // Show relavant toggle
        this_concertina.find('[data-toggled-by~="'+toggler_id+'"]').show();
    }

    $(this).find('.radio-concertina input[type=radio]').change(selectVisibility);

    // Hide all toggles
    $(this).find('.radio-concertina [data-toggled-by]').hide();

    // Show for any already checked radio buttons
    $(this).find('.radio-concertina input[type=radio]:checked').each(selectVisibility);
})
