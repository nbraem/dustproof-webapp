var ready_highcharts;
ready_highcharts = function() {
  Highcharts.setOptions({
    global: {
      useUTC: false
    },
    lang: {
      decimalPoint: ",",
      thousandsSep: " ",
      drillUpText: "Terug naar {series.name}.",
      loading: "Laden...",
      noData: "Geen data",
      printChart: "Grafiek afdrukken",
      downloadJPEG: "Download JPEG afbeelding",
      downloadPNG: "Download PNG afbeelding",
      downloadSVG: "Download SVG vector afbeelding",
      resetZoom: "Uitzoomen",
      resetZoomTitle: "Uitzoomen",
      shortMonths: [ "jan" , "feb" , "mrt" , "apr" , "mei" , "jun" , "jul" , "aug" , "sep" , "okt" , "nov" , "dec"],
      months: ['januari', 'februari', 'maart', 'april', 'mei', 'juni',  'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
      weekdays: ['Zondag', 'Maandag', 'Dinsdag', 'Woensdag', 'Donderdag', 'Vrijdag', 'Zaterdag']
    }
  });
};

$(document).ready(ready_highcharts);
$(document).on('page:load', ready_highcharts);
