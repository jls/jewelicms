/* This file implements the hints hiding functionality. this can/should be rewritten as jquery or something else. and it should be linked to real preferences in the database eventually. */
// The variable we'll use to check if jeweli hints cookie is set
var cookieName = "show_jeweli_hint_boxes";

jQuery(document).ready(function($) {
  pageInit();

function pageInit()
{	
	if ($('#show_hints') == null) return;
	$('#show_hints').attr('checked', (readCookie(cookieName) == null || readCookie(cookieName) == "true" || readCookie(cookieName) == true) ? true : false); // not sure if this statement is needed, but it's thorough at least
	$('#show_hints').bind('click', updateHintsCookie);	
	$('#close-btn').bind('click', closeHint);	
	checkHints();
    // This code runs as soon as possible once the DOM is available
   // $('myButton').observe('click', buttonClickHandler);
}


// Closes the element with id "hint-toggle"
function closeHint () {
	$('#hint-toggle').css('display', 'none');		
}

// Gets the value of the checkbox
function updateHintsCookie () {
	var v = $('#show_hints').checked;
	createCookie(cookieName, v);
}

// Checks to see if hints should be on or off... and turns them on or off
function checkHints () {
	var displayVal = "none", h = readCookie(cookieName);

	if (h == null) {
		createCookie(cookieName, true);
		checkHints();
	} else {
		displayVal = (h == "true") ? "block" : "none";		
		$('#hint-toggle').css('display', displayVal);		
	}	
}

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

});


