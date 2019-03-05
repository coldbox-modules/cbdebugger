/**
* My Event Handler Hint
*/
component{

	// Index
	any function index( event,rc, prc ){
	}

	any function noDebugger( event, rc, prc ){
		hideDebugger();
		event.renderData( data="<h1>Hello</h1>" );
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
	}

}