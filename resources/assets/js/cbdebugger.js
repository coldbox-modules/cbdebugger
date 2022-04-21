import Alpine from "alpinejs";
// Load Plugins
// Using common js due to NOT being on webpack5, the esm was giving us issues
// Once we update to elixir 4, try it again
import morph from "@alpinejs/morph/dist/module.cjs";
// Load Custom Components
import ModulesPanel from "./components/ModulesPanel";
import RequestTrackerPanel from "./components/RequestTrackerPanel";

// For easy referencing
window.Alpine = Alpine;

// Register Plugins
Alpine.plugin( morph );

// Register Components
Alpine.data( "modulesPanel", ModulesPanel );
Alpine.data( "requestTrackerPanel", RequestTrackerPanel );

// Startup your engines!!!!!!!!
Alpine.start();

// Init the coldbox debugger module
window.coldboxDebugger = ( () => {
	/**
	 * Listen to dom load and attach
	 */
	window.onload = ()=> console.log( "ColdBox Debugger Loaded!" );

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
