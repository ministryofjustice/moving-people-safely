var autos = [
  "crown_court",
  "magistrates_court",
  "prison",
  "police_custody",
  "immigration_removal_centre",
  "youth_secure_estate"
]

for (i = 0, tot = autos.length; i < tot; i++) {
  if (document.querySelector('#'+autos[i])) {
    accessibleAutocomplete.enhanceSelectElement({
      selectElement: document.querySelector('#'+autos[i]),
      id: autos[i] // To match it to the existing <label>.
    });
  };
}
