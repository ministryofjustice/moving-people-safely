if (document.querySelector('#crown_court')) {
  accessibleAutocomplete.enhanceSelectElement({
    selectElement: document.querySelector('#crown_court'),
    id: 'crown_court' // To match it to the existing <label>.
  });
};

if (document.querySelector('#magistrates_court')) {
  accessibleAutocomplete.enhanceSelectElement({
    selectElement: document.querySelector('#magistrates_court'),
    id: 'magistrates_court' // To match it to the existing <label>.
  });
};

if (document.querySelector('#prison')) {
  accessibleAutocomplete.enhanceSelectElement({
    selectElement: document.querySelector('#prison'),
    id: 'prison' // To match it to the existing <label>.
  });
};

if (document.querySelector('#police_custody')) {
  accessibleAutocomplete.enhanceSelectElement({
    selectElement: document.querySelector('#police_custody'),
    id: 'police_custody' // To match it to the existing <label>.
  });
};
