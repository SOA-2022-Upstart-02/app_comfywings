var results = [];
var numResults = 0;
var selectedIndex = -1;

$(function() {
  bind_airport_autocomplete('airport_origin_input');
  bind_airport_autocomplete('airport_destination_input');
}).on('click', clearResults);;


function bind_airport_autocomplete(autocomplete_id) {

  var ac = $(`#${autocomplete_id}`);
  var wrap = $('<div>')
    .addClass('autocomplete-wrapper')
    .insertBefore(ac)
    .append(ac);

  var list = $('<div>')
    .addClass('autocomplete-results')
    .appendTo(wrap);

  ac.on('click', function(e) {
    e.stopPropagation();
  }).on('focus keyup', e => search(e, list));

  list.on('click', '.autocomplete-result', function(e) {
    e.preventDefault();
    e.stopPropagation();
    selectIndex($(this).data('index'), ac);
  })
}


function clearResults() {
  results = [];
  numResults = 0;
  $('.autocomplete-results').empty();
}

function selectIndex(index, ac) {
  if (results.length >= index + 1) {
    code = results[index].iata_code;
    ac.val(code);
    clearResults();
  }
}

function search(e, list) {
  if (e.which === 38 || e.which === 13 || e.which === 40) {
    return;
  }

  ac = $(e.target);
  if (ac.val().length > 0) {
    $.get(`airport?iata_code=${ac.val()}`, function(data) {
      results = JSON.parse(JSON.parse(data)).airports;
      numResults = results.length;
      var divs = results.map(function(r, i) {
        return `<div class="autocomplete-result" data-index="${i}">
                  <div><b>${r.iata_code}</b> - ${r.airport_name}</div>
                  <div class="autocomplete-location">${r.city_airport_name}, ${r.country}</div>
                </div>`;
      });

      selectedIndex = -1;
      list.html(divs.join(''))
        .attr('data-highlight', selectedIndex);
    });

  } else {
    clearResults()
  }
}