const searchInput = document.getElementById('search');
const searchResults = document.getElementById('search-results');

function fetchResults(searchTerm) {
  fetch(`/search?term=${searchTerm}`)
    .then(response => response.json())
    .then(data => displayResults(data));
}

function displayResults(results) {
  searchResults.innerHTML = '';

  results.forEach(result => {
    const listItem = document.createElement('li');
    listItem.textContent = result;
    searchResults.appendChild(listItem);
  });
}

searchInput.addEventListener('input', () => {
  const allSearchTerms = searchInput.value.trim();
  const terms = allSearchTerms.split(',')
  const searchTerm = terms[terms.length - 1].trim();

  if (searchTerm !== '') {
    fetchResults(searchTerm);
  } else {
    searchResults.innerHTML = '';
  }
});
