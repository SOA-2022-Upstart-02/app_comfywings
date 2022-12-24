var ac = $('#airport_code')
  .on('click', function(e) {
    e.stopPropagation();
  })
  .on('focus keyup', search);

var wrap = $('<div>')
  .addClass('autocomplete-wrapper')
  .insertBefore(ac)
  .append(ac);

var list = $('<div>')
  .addClass('autocomplete-results')
  .on('click', '.autocomplete-result', function(e) {
    e.preventDefault();
    e.stopPropagation();
    selectIndex($(this).data('index'));
  })
  .appendTo(wrap);

$(document)
  .on('mouseover', '.autocomplete-result', function(e) {
    var index = parseInt($(this).data('index'), 10);
    if (!isNaN(index)) {
      list.attr('data-highlight', index);
    }
  })
  .on('click', clearResults);

function clearResults() {
  results = [];
  numResults = 0;
  list.empty();
}

function selectIndex(index) {
  if (results.length >= index + 1) {
    ac.val(results[index].iata);
    clearResults();
  }
}

var results = [];
var numResults = 0;
var selectedIndex = -1;

function search(e) {
  if (e.which === 38 || e.which === 13 || e.which === 40) {
    return;
  }

  if (ac.val().length > 0) {
    results = [{
      iata: 'MAD',
      name: 'abcd',
      city: 'fsadfas',
      country: 'adfssafgawegwew'
    }, {
      iata: 'TPE',
      name: 'abcd',
      city: 'fsadfas',
      country: 'adfssafgawegwew'
    }]
    numResults = results.length;

    var divs = results.map(function(r, i) {
      return '<div class="autocomplete-result" data-index="' + i + '">' +
        '<div><b>' + r.iata + '</b> - ' + r.name + '</div>' +
        '<div class="autocomplete-location">' + r.city + ', ' + r.country + '</div>' +
        '</div>';
    });

    selectedIndex = -1;
    list.html(divs.join(''))
      .attr('data-highlight', selectedIndex);

  } else {
    numResults = 0;
    list.empty();
  }
}

$.get("individual_airport?iata_code=TP", function(data) {
    console.log(data)
  });