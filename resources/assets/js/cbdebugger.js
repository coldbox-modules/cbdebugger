import $cb from "jquery";
import Alpine from "alpinejs";
// Using common js due to NOT being on webpack5, the esm was giving us issues
// Once we update to elixir 4, try it again
import morph from "@alpinejs/morph/dist/module.cjs";

window.Alpine = Alpine;
Alpine.plugin( morph );
Alpine.start();

/**
 * Listen to dom load
 */
window.onload = ()=> console.log( "ColdBox Debugger Loaded!" );

/**
 * Scroll to the top of the profiler report
 */
window.cbdScrollTo = function( id ){
	let top = id == undefined ? 0 : document.getElementById( id ).offsetTop - 10;
	window.scroll( {
		top      : top,
		behavior : "smooth"
	} );
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
