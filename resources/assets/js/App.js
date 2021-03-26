import $cb from "jquery";

$cb( document ).ready( function(){
	window.cbDebuggerUrl = $( "#cbd-debugger" ).data().appurl;
	console.log( "ColdBox Debugger Loaded at " + window.cbDebuggerUrl );
} );

/**
 * Send an ajax command to clear the profilers
 */
window.cbdClearProfilers = function(){
	$( "#cbd-buttonClearProfilers > svg" ).addClass( "cbd-spinner" );
	$cb.getJSON( cbDebuggerUrl + "cbDebugger/clearProfilers", ( data ) => {
		if ( data.error ){
			alert( data.messages.toString() );
		} else {
			$( "#cbd-profilers" ).html( data.messages.toString() );
		}
		$( "#cbd-buttonClearProfilers > svg" ).removeClass( "cbd-spinner" );
		cbdRefreshProfilers();
	} );
};

/**
 * Send an ajax command to render the profilers
 */
window.cbdRefreshProfilers = function(){
	$( "#cbd-buttonRefreshProfilers > svg" ).addClass( "cbd-spinner" );
	$cb.get( cbDebuggerUrl + "cbDebugger/renderProfilers", ( response ) => {
		$( "#cbd-buttonRefreshProfilers > svg" ).removeClass( "cbd-spinner" );
		$( "#cbd-profilers" ).html( response );
	} );
};

/**
 * Send an ajax command to render the profilers
 * @param {*} id The profiler id to load
 */
window.cbdGetProfilerReport = function( id ){
	$( "#cbd-buttonGetProfilerReport" + id + " > svg" ).addClass( "cbd-spinner" );
	$cb.get(
		cbDebuggerUrl + "cbDebugger/renderProfilerReport",
		{ id: id },
		( response ) => {
			$( "#cbd-profilers" ).html( response );
			$( "#cbd-buttonGetProfilerReport" + id + " > svg" ).removeClass( "cbd-spinner" );
		}
	);
};

/**
 * Toggle display from block to none
 * @param {*} targetDiv The target div
 * @param {*} displayStyle The display style to test
 */
window.fw_toggleDiv = function( targetDiv, displayStyle ){
	// toggle a div with styles, man I miss jquery
	if ( displayStyle == null ){ displayStyle = "block"; }
	var target = document.getElementById( targetDiv );
	if ( target.style.display == displayStyle ){
		target.style.display = "none";
	}
	else {
		target.style.display = displayStyle;
	}
};

/**
 * Toggle on/off debug content views
 * @param {*} divid The div id to change the class on
 */
window.fw_toggle = function( divid ){
	if ( document.getElementById( divid ).className == "fw_debugContent" ){
		document.getElementById( divid ).className = "fw_debugContentView";
	}
	else {
		document.getElementById( divid ).className = "fw_debugContent";
	}
};

/**
 * Toggle on/off a row
 * @param {*} divid The div id to change the class on
 */
window.fw_toggleRow = function( divid ){
	if ( document.getElementById( divid ).className == "fw_hide" ){
		document.getElementById( divid ).className = "fw_showRow";
	}
	else {
		document.getElementById( divid ).className = "fw_hide";
	}
};

/**
 * Toggle on/off rc
 * @param {*} divid The div id to change the class on
 */
window.fw_poprc = function( divid ){
	var _div = document.getElementById( divid );
	if ( _div.className == "hideRC" )
		document.getElementById( divid ).className = "showRC";
	else
		document.getElementById( divid ).className = "hideRC";
};

/**
 * Open a new window
 * @param {*} mypage the target page
 * @param {*} myname the target name
 * @param {*} w width
 * @param {*} h height
 * @param {*} features features to add
 */
window.fw_openwindow = function( mypage,myname,w,h,features ) {
	if ( screen.width ){
		var winl = ( screen.width-w )/2;
		var wint = ( screen.height-h )/2;
	}
	else {
		winl = 0;wint =0;
	}
	if ( winl < 0 ) winl = 0;
	if ( wint < 0 ) wint = 0;

	var settings = "height=" + h + ",";
	settings += "width=" + w + ",";
	settings += "top=" + wint + ",";
	settings += "left=" + winl + ",";
	settings += features;
	win = window.open( mypage,myname,settings );
	win.window.focus();
};

/**
 * Reinit ColdBox by submitting the reinit form
 * @param {*} usingPassword Are we using a password or not, if we do we ask the user for it
 */
window.fw_reinitframework = function( usingPassword ){
	var reinitForm = document.getElementById( "fw_reinitcoldbox" );
	if ( usingPassword ){
		reinitForm.fwreinit.value = prompt( "Reinit Password?" );
		if ( reinitForm.fwreinit.value.length ){
			reinitForm.submit();
		}
	} else {
		reinitForm.submit();
	}
};

/**
 * Relocate to a new panel with a frequency
 * @param {*} panel The panel to show
 * @param {*} frequency The frequency to set
 * @param {*} urlBase The url base
 */
window.fw_pollmonitor = function( panel, frequency, urlBase ){
	window.location = urlBase + "?debugpanel=" + panel + "&frequency=" + frequency;
};

/**
 * Execute a URL command via Ajax
 * @param {*} commandURL The url + the debugCommand on it
 * @param {*} verb The HTTP Verb to use for the request
 * @returns The response text
 */
window.fw_cboxCommand = function( commandURL, verb ){
	if ( verb == null ){
		verb = "GET";
	}
	var request = new XMLHttpRequest();
	request.open( verb, commandURL, false );
	request.send();
	return request.responseText;
};

/**
 * Show group queries and hide timeline queries
 */
window.fw_showGroupedQueries = function() {
	fw_toggleDiv( "timelineQueries", "none" );
	fw_toggleDiv( "groupedQueries", "block" );
};

/**
 * Show timeline queries and hide group queries
 */
window.fw_showTimelineQueries = function() {
	fw_toggleDiv( "groupedQueries", "none" );
	fw_toggleDiv( "timelineQueries", "block" );
};
