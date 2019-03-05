/**
* My BDD Test
*/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "Debugger Module", function(){

			beforeEach(function( currentSpec ){
				setup();
			});

			it( "should register components", function(){
				var obj = getWireBox().getInstance( "Timer@cbdebugger" );
				expect(	obj ).toBeComponent();

				var obj = getWireBox().getInstance( "DebuggerService@cbdebugger" );
				expect(	obj ).toBeComponent();
			});

			it( "should run integration", function(){
				var event = execute( event="main.index", renderResults=true );
				//expect( event.getValue( "cbox_rendered_content" ) ).toMatch( "ColdBox Debugging Information" );
			});

		});
	}

}