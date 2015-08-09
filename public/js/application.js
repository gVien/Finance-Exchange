$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
  addComment()
  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});


var addComment = function() {
  $(".comment-box").on("submit", "#comment-form", function(event) {
  	event.preventDefault();
  	var data = $(this).serialize();

  	newComment(data);
  	// debugger;
  	// console.log(data)
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

