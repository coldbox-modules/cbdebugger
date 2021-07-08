import $cb from "jquery";

$cb( document ).ready( function(){
	window.cbDebuggerUrl = $cb( "#cbd-debugger" ).data().appurl;
	console.log( "ColdBox Debugger Loaded at " + window.cbDebuggerUrl );
} );

/**
 * Send an ajax command to clear the profilers
 */
window.cbdClearProfilers = function(){
	$cb( "#cbd-buttonClearProfilers > svg" ).addClass( "cbd-spinner" );
	$cb.getJSON( cbDebuggerUrl + "cbDebugger/clearProfilers", ( data ) => {
		if ( data.error ){
			alert( data.messages.toString() );
		} else {
			$cb( "#cbd-profilers" ).html( data.messages.toString() );
		}
		$cb( "#cbd-buttonClearProfilers > svg" ).removeClass( "cbd-spinner" );
		cbdRefreshProfilers();
	} );
};

/**
 * Send an ajax command to render the profilers
 */
window.cbdRefreshProfilers = function(){
	$cb( "#cbd-buttonRefreshProfilers > svg" ).addClass( "cbd-spinner" );
	$cb.get( cbDebuggerUrl + "cbDebugger/renderProfilers", ( response ) => {
		$cb( "#cbd-buttonRefreshProfilers > svg" ).removeClass( "cbd-spinner" );
		$cb( "#cbd-profilers" ).html( response );
	} );
};

/**
 * Scroll to the top of the profiler report
 */
window.cbdScrollToProfilerReport = function(){
	$cb( document ).scrollTop( $cb( "#cbd-profilers" ).offset().top - 10 );
};

/**
 * Send an ajax command to render the profiler report from the visualizer
 * @param {*} id The profiler id to load
 * @param {*} isVisualizer Are we in visualizer mode or not
 */
window.cbdGetProfilerReport = function( id, isVisualizer ){
	$cb( "#cbd-buttonGetProfilerReport-" + id + " > svg" ).addClass( "cbd-spinner" );
	$cb.get(
		cbDebuggerUrl + "cbDebugger/renderProfilerReport",
		{ id: id, isVisualizer: isVisualizer || false },
		( response ) => {
			$cb( "#cbd-profilers" ).html( response );
			$cb( "#cbd-buttonGetProfilerReport-" + id + " > svg" ).removeClass( "cbd-spinner" );
			cbdScrollToProfilerReport();
		}
	);
};

/**
 * Reload all modules
 * @param {*} btn The caller button
 */
window.cbdReloadAllModules = function( btn ){
	$cb( this ).find( "svg" ).addClass( "cbd-spinner" );
	$cb.getJSON(
		cbDebuggerUrl + "cbDebugger/reloadAllModules",
		( data ) => {
			if ( data.error ){
				alert( data.messages.toString() );
			} else {
				alert( "All modules reloaded!" );
			}
			$cb( this ).find( "svg" ).removeClass( "cbd-spinner" );
		}
	);
};

/**
 * Reload a module
 * @param {*} module The module to reload
 * @param {*} btn The caller button
 */
window.cbdReloadModule = function( module, btn ){
	$cb( this ).find( "svg" ).addClass( "cbd-spinner" );
	$cb.getJSON(
		cbDebuggerUrl + "cbDebugger/reloadModule",
		{ module: module },
		( data ) => {
			if ( data.error ){
				alert( data.messages.toString() );
			} else {
				alert( module + " reloaded!" );
			}
			$cb( this ).find( "svg" ).removeClass( "cbd-spinner" );
		}
	);
};

/**
 * Unload a module
 * @param {*} module The module to reload
 * @param {*} btn The caller button
 */
window.cbdUnloadModule = function( module, btn ){
	$cb( this ).find( "svg" ).addClass( "cbd-spinner" );
	$cb.getJSON(
		cbDebuggerUrl + "cbDebugger/unloadModule",
		{ module: module },
		( data ) => {
			if ( data.error ){
				alert( data.messages.toString() );
			} else {
				alert( module + " unloaded!" );
				$cb( "#cbd-modulerow-" + module ).remove();
			}
			$cb( this ).find( "svg" ).removeClass( "cbd-spinner" );
		}
	);
};

/**
 * Activate the request tracker monitor reloading frequency
 * @param {*} frequency The frequency in seconds to refresh
 */
window.cbdStartDebuggerMonitor = function( frequency ){
	if ( frequency == 0 ){
		cbdStopDebuggerMonitor();
		return;
	}
	window.cbdRefreshMonitor = setInterval( cbdRefreshProfilers, frequency * 1000 );

	// Start it
	console.log( "Started ColdBox Debugger Profiler Refresh using " + frequency + " seconds" );
};

/**
 * Stop the debugger refresh monitor
 */
window.cbdStopDebuggerMonitor = function(){
	if ( "cbdRefreshMonitor" in window ){
		clearInterval( window.cbdRefreshMonitor );
		console.log( "Stopped ColdBox Debugger Profiler Refresh" );
	}
};

/****************** MIGRATE BELOW ****************/

/**
 * Toggle on/off debug content views
 * @param {*} divid The div id to toggle on and off
 */
window.cbdToggle = function( divid ){
	$cb( "#" + divid ).slideToggle();
};

/**
 * Open a new window
 * @param {*} mypage the target page
 * @param {*} myname the target name
 * @param {*} w width
 * @param {*} h height
 * @param {*} features features to add
 */
window.cbdOpenWindow = function( mypage, myname, w, h, features ) {
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
window.cbdReinitFramework = function( usingPassword ){
	var reinitForm = document.getElementById( "cbdReinitColdBox" );
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
 * Show group queries and hide timeline queries
 */
window.cbdShowGroupedQueries = function() {
	// Watch out for double toggles
	if ( $cb( "#cbdGroupedQueries" ).css( "display" ) == "block" ){
		return;
	}
	$cb( "#cbdButtonGroupedQueries" ).addClass( "cbd-selected" );
	$cb( "#cbdButtonTimelineQueries" ).removeClass( "cbd-selected" );
	$cb( "#cbdTimelineQueries" ).slideUp();
	$cb( "#cbdGroupedQueries" ).slideDown();
};

/**
 * Show timeline queries and hide group queries
 */
window.cbdShowTimelineQueries = function() {
	// Watch out for double toggles
	if ( $cb( "#cbdTimelineQueries" ).css( "display" ) == "block" ){
		return;
	}
	$cb( "#cbdButtonTimelineQueries" ).addClass( "cbd-selected" );
	$cb( "#cbdButtonGroupedQueries" ).removeClass( "cbd-selected" );
	$cb( "#cbdTimelineQueries" ).slideDown();
	$cb( "#cbdGroupedQueries" ).slideUp();
};

/**
 * Show group queries and hide timeline queries for orm
 */
window.cbdShowGroupedOrmQueries = function() {
	// Watch out for double toggles
	if ( $cb( "#cbdGroupedOrmQueries" ).css( "display" ) == "block" ){
		return;
	}
	$cb( "#cbdButtonGroupedOrmQueries" ).addClass( "cbd-selected" );
	$cb( "#cbdButtonTimelineOrmQueries" ).removeClass( "cbd-selected" );
	$cb( "#cbdTimelineOrmQueries" ).slideUp();
	$cb( "#cbdGroupedOrmQueries" ).slideDown();
};

/**
 * Show timeline queries and hide group queries for orm
 */
window.cbdShowTimelineOrmQueries = function() {
	// Watch out for double toggles
	if ( $cb( "#timelineQueries" ).css( "display" ) == "block" ){
		return;
	}
	$cb( "#cbdButtonTimelineOrmQueries" ).addClass( "cbd-selected" );
	$cb( "#cbdButtonGroupedOrmQueries" ).removeClass( "cbd-selected" );
	$cb( "#cbdTimelineOrmQueries" ).slideDown();
	$cb( "#cbdGroupedOrmQueries" ).slideUp();
};

/**
 * Copy a div's code to the clipboard
 * @param {*} id The id of the element's content to copy to the clipboard
 */
window.copyToClipboard = function( id ) {
	var elm = document.getElementById( id );
	// for Internet Explorer
	if ( document.body.createTextRange ) {
		var range = document.body.createTextRange();
		range.moveToElementText( elm );
		range.select();
		document.execCommand( "Copy" );
	} else if ( window.getSelection ) {
		// other browsers
		var selection = window.getSelection();
		var range = document.createRange();
		range.selectNodeContents( elm );
		selection.removeAllRanges();
		selection.addRange( range );
		document.execCommand( "Copy" );
	}
};