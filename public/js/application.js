$(document).ready(function() {


	submitStockForm();	//apparenntly calling 2 posts of the same link are too buggy
	addComment();
});


/****** functions to add comments with Ajax ******/
var addComment = function() {
  $("#page-layout-data").on("submit", "#comment-form", function(event) {
  	event.preventDefault();
  	var data = $(this).serialize();

  	newComment(data);
  	// debugger;
  	console.log(data)
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
		console.log("the response from server: ", response)
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
		data: data
	}).done(function(response) {
		// debugger;
		appendProfilePage(response);
		console.log("response from field: ", response);
	})
}

var appendProfilePage = function(response) {
	$("#page-layout-data").html(response);
  $("#invalid-sym").remove();       //remove the invalid-symbol error if it exists
  $(".symbol-box").append(response.symbol_error); //add the invalid symbol error, if it's passed here
  $("#stocks-form")[0].reset();
}
/****** END functions to populate Comment Box and Data with Ajax ******/
