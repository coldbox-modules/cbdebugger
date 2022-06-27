import cbAlpine from "alpinejs";

// Load Custom Components
import ModulesPanel from "./components/ModulesPanel";
import RequestTrackerPanel from "./components/RequestTrackerPanel";

// Init the coldbox debugger module
window.coldboxDebugger = ( () => {

	/**
	 * Listen to alpine startup to load cbDebugger components
	 */
	document.addEventListener('alpine:init', () => {
		// Register Components so our prefixed alpine version can read it.
		window.Alpine.data( "cbdModulesPanel", ModulesPanel );
		window.Alpine.data( "cbdRequestTrackerPanel", RequestTrackerPanel );
		//console.log( "Registering cbDebugger Alpine Components!" );
	});

	/**
	 * Listen to DOM to see if we load our Alpine or use a version of Alpine
	 */
	window.addEventListener( "load", ( event ) => {
		// Verify if alpine is already loaded in the window
		if( !window.hasOwnProperty( "Alpine" ) ){
			window.Alpine = cbAlpine;
			// Startup your engines!!!!!!!!
			window.Alpine.start();
			//console.log( "Alpine not loaded, loading it!" );
		} else {
			console.log( "Alpine already loaded, cbDebugger will use it!" );
		}
		console.log( "ColdBox Debugger Loaded!" );
	} );

	return {
		/**
		 * Copy a div's code to the clipboard
		 *
		 * @param {*} id The id of the element's content to copy to the clipboard
		 */
		copyToClipboard : function( id ) {
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
		},

		/**
		 * Smoot scrolling baby
		 * @param {*} id Optional dom id to scroll to else to the top.
		 */
		scrollTo : function( id ){
			let top = id == undefined ? 0 : document.getElementById( id ).offsetTop - 10;
			window.scroll( {
				top      : top,
				behavior : "smooth"
			} );
		},

		/**
		* Open a new window
		*
		* @param {*} mypage the target page
		* @param {*} myname the target name
		* @param {*} w width
		* @param {*} h height
		* @param {*} features features to add
		*/
		openWindow : function( mypage, myname, w, h, features ) {
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
	   }
	};
} )();
