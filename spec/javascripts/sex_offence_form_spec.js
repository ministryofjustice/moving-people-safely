describe("Sex offence form script", function() {
  var $details_wrapper;

  beforeEach(function(){
    loadFixtures("sex_offence_form.html");
    $.fn.toggle_sex_offence_details_area();
    $details_wrapper = $("#sex_offences_sex_offence_details").closest(".form-group");
  });

  it("hides the text area on intial load i.e. no radio button has been selected yet", function(){
    expect($details_wrapper.is(':visible')).toBe(false);
  });

  it("only displays the details area when 'under 18' is selected", function(){
    $("#sex_offences_sex_offence_victim_under_18").click();
    expect($details_wrapper.is(':visible')).toBe(true);

    $("#sex_offences_sex_offence_victim_adult_male").click();
    expect($details_wrapper.is(':visible')).toBe(false);

    $("#sex_offences_sex_offence_victim_adult_female").click();
    expect($details_wrapper.is(':visible')).toBe(false);

    // assert can display the details area again
    $("#sex_offences_sex_offence_victim_under_18").click();
    expect($details_wrapper.is(':visible')).toBe(true);
  });
});
