import Alpine from "alpinejs";
// Using common js due to NOT being on webpack5, the esm was giving us issues
// Once we update to elixir 4, try it again
import morph from "@alpinejs/morph/dist/module.cjs";

window.Alpine = Alpine;
Alpine.plugin( morph );
Alpine.start();

/**
 * Listen to dom load and attach
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


/**
 * Open a new window
 *
 * @param {*} mypage the target page
 * @param {*} myname the target name
 * @param {*} w width
 * @param {*} h height
 * @param {*} features features to add
 */
window.cbdOpenWindow = function( mypage, myname, w, h, features ) {
	let winl = screen.width ? ( screen.width - w ) / 2 : 0;
	let wint = screen.width ? ( screen.height - h ) / 2 : 0;
	if ( winl < 0 ) winl = 0;
	if ( wint < 0 ) wint = 0;
	let win = window.open(
		mypage,
		myname,
		`height=${h},width=${w},top=${wint},left=${winl}+${features}`
	);
	win.window.focus();
};

/**
 * Copy a div's code to the clipboard
 *
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
