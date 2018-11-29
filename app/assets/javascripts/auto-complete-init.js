accessibleElements = document.querySelectorAll('.mps-autocomplete');

for (i = 0, l = accessibleElements.length; i < l; ++i) {
  accessibleAutocomplete.enhanceSelectElement({
    selectElement: accessibleElements[i]
  });
};
