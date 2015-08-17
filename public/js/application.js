$(document).ready(function() {


	submitStockForm();	
	addComment();
});


/****** functions to add comments with Ajax ******/
var addComment = function() {
  $("#page-layout-data").on("submit", "#comment-form", function(event) {
  	event.preventDefault();
  	var data = $(this).serialize();

  	newComment(data);
  	// debugger;
  	// console.log(data)
  });
}

var newComment = function(data) {
	var form = $("#page-layout-data").find("#comment-form");
	// debugger
	$.ajax({
		url: form.attr("action"),
		method: form.attr("method"),
		data: data,
		dataType: "json"
	}).done(function(response) {
		// debugger;
		// console.log("the response from server: ", response)
		appendComment(response)
	});
}

var appendComment = function(responseFromServer) {
	$("#page-layout-data").find(".comment-box").append("<p>"+responseFromServer.first_name + " " + responseFromServer.last_name + ": " + responseFromServer.comment + "</p>");
	$("#page-layout-data").find("#comment-form")[0].reset();	//or $("#comment").val("") //note that it's in a nodeList
}

/****** END functions to add comments with Ajax ******/


/****** functions to populate Comment Box and Data with Ajax ******/

var submitStockForm = function() {
	$(".symbol-box").on("submit", "#stocks-form", function(event) {
		event.preventDefault();
  	var data = $(this).serialize();

  	// debugger;
  	// console.log(data)
  	renderProfilePage(data);
	})
}

var renderProfilePage = function(data) {
	var submitForm = $("#stocks-form");
	$.ajax({
		url: submitForm.attr("action"),
		method: "post",
		data: data,
		dataType: "JSON",
    beforeSend: function() {
      // $(".display-page").hide();
      appendAjaxLoader();
    }
	}).done(function(response) {
        $(".ajax-loader").remove();
		appendProfilePage(response);
		appendStockChart(response.data)
		// console.log("response from field: ", response);
	})
}

var appendProfilePage = function(response) {
	$("#page-layout-data").html(response.page_content);
  $("#invalid-sym").remove();       //remove the invalid-symbol error if it exists
  $(".symbol-box").append(response.symbol_error); //add the invalid symbol error, if it's passed here
  $("#stocks-form")[0].reset();
}
/****** END functions to populate Comment Box and Data with Ajax ******/

// Append Ajax loader

var appendAjaxLoader = function() {
    $("#page-layout-data").prepend("<div class='ajax-loader'><img src='/ajax-loader.gif'></div>")
}


/* HIGH CHARTS CODES ARE BELOW */

var appendStockChart = function (data) { 
            // set the allowed units for data grouping
           var groupingUnits = [[
                'day',                         // unit name
                [1]                             // allowed multiples
            ], [
                'month',
                [1, 2, 3, 4, 6]
            ]];

   $('.chart').highcharts('StockChart', {

            rangeSelector: {
                selected: 1
            },

            title: {
                text: data[0].symbol + ' Historical Price'
            },

            yAxis: [{
                labels: {
                    align: 'right',
                    x: -3
                },
                title: {
                    text: 'Price'
                },
                height: '60%',
                lineWidth: 2
            }, {
                labels: {
                    align: 'right',
                    x: -3
                },
                title: {
                    text: 'Volume'
                },
                top: '65%',
                height: '35%',
                offset: 0,
                lineWidth: 2
            }],

            series: [{
                type: 'candlestick',
                name: data[0].symbol,
                data: formatPrice(data),
                dataGrouping: {
                    units: groupingUnits
                }
            }, {
                type: 'column',
                name: 'Volume',
                data: formatVolume(data),
                yAxis: 1,
                dataGrouping: {
                    units: groupingUnits
                }
            }]
        });
    };

//a function to format the data sent from the server into an array of
// [[time, openPrice, highPrice, lowPrice, closePrice],...] where time is
// in milliseconds (use Date.parse(time))
// data order from back end is newest to oldest. Highchart requires
// data to be oldest to newest
var formatPrice = function(data) {
	var ohlc = [],
			len = data.length;

	for (var i = len - 1; i >= 0; i--) {
		d = data[i];
		ohlc.push([Date.parse(d.date), round2Tenth(d.open), round2Tenth(d.high), round2Tenth(d.low), round2Tenth(d.close)]);
	}
	return ohlc;
}

// a function to format the volume and time
// [[time, volume], ...]
var formatVolume = function(data) {
	var volume = [],
			len = data.length;

	for (var i = len - 1; i >= 0; i--) {
		d = data[i];
		volume.push([Date.parse(d.date), d.volume ]);
	}
	return volume;
}

var round2Tenth = function(number) {
    return Math.round(number * 1e2) / 1e2;
};

