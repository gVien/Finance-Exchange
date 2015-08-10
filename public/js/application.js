$(document).ready(function() {

  
	// populateProfileWithPages();	//apparenntly calling 2 posts of the same link are too buggy
	addComment();
});


/****** functions to add comments with Ajax ******/
var addComment = function() {
  $(".comment-box").on("submit", "#comment-form", function(event) {
  	event.preventDefault();
  	var data = $(this).serialize();

  	newComment(data);
  	// debugger;
  	console.log(data)
  });
}

var newComment = function(data) {
	var form = $("#comment-form");
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
	$(".comment-box").append("<p>"+responseFromServer.first_name + " " + responseFromServer.last_name + ": " + responseFromServer.comment + "</p>");
	$("#comment-form")[0].reset();	//or $("#comment").val("") //note that it's in a nodeList
}

/****** END functions to add comments with Ajax ******/


/****** functions to populate Comment Box and Data with Ajax ******/

var populateProfileWithPages = function() {
	$(".symbol-box").on("submit", "#symbol-form", function(event) {
		event.preventDefault();
  	var data = $(this).serialize();

  	// debugger;
  	console.log(data)
  	newFormFields(data);
	})
}

var newFormFields = function(data) {
	var submitForm = $("#symbol-form");
	$.ajax({
		url: submitForm.attr("action"),
		method: "post",
		data: data
	}).done(function(response) {
		// debugger;
		appendProfile(response);
		console.log("response from field: ", response);
	})
}

var appendProfile = function(response) {
	$("#page-layout-data").html(response);
}
/****** END functions to populate Comment Box and Data with Ajax ******/