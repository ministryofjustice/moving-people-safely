var autos = [
  "crown_court",
  "magistrates_court",
  "prison",
  "police_custody",
  "immigration_removal_centre",
  "youth_secure_estate",
  "auto_ethnicity"
]

for (i = 0, tot = autos.length; i < tot; i++) {
  var auto = autos[i];
  if (document.querySelector('#' + auto)) {
    accessibleAutocomplete.enhanceSelectElement({
      selectElement: document.querySelector('#'+auto),
      id: auto // To match it to the existing <label>.
    });
  };
}
