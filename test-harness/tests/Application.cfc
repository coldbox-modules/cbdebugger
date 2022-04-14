/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component {

	// UPDATE THE NAME OF THE MODULE IN TESTING BELOW
	request.MODULE_NAME = "cbdebugger";
	request.MODULE_PATH = "cbdebugger";

	// APPLICATION CFC PROPERTIES
	this.name               = "#request.MODULE_NAME# testing suite";
	this.sessionManagement  = true;
	this.sessionTimeout     = createTimespan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimespan( 0, 0, 15, 0 );
	this.setClientCookies   = true;

	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	// The application root
	rootPath                 = reReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/root" ] = rootPath;

	// The module root path
	moduleRootPath = reReplaceNoCase(
		rootPath,
		"#request.MODULE_PATH#(\\|/)test-harness(\\|/)",
		""
	);
	this.mappings[ "/moduleroot" ]            = moduleRootPath;
	this.mappings[ "/#request.MODULE_NAME#" ] = moduleRootPath & "#request.MODULE_NAME#";

	this.mappings[ "/cborm" ] = rootPath & "modules/cborm";
	this.mappings[ "/quick" ] = rootPath & "modules/quick";

	// ORM definitions
	this.datasource = "coolblog";
	this.ormEnabled = "true";

	this.ormSettings = {
		cfclocation           : [ rootPath & "models" ],
		logSQL                : true,
		dbcreate              : "none",
		secondarycacheenabled : false,
		cacheProvider         : "ehcache",
		automanageSession     : false,
		flushAtRequestEnd     : false,
		eventhandling         : true,
		eventHandler          : "cborm.models.EventHandler",
		skipcfcWithError      : false
	};

	// request start
	public boolean function onRequestStart( String targetPage ){
		if ( url.keyExists( "fwreinit" ) ) {
			ormReload();
			if ( structKeyExists( server, "lucee" ) ) {
				pagePoolClear();
			}
		}

		// Cleanup
		if ( !isNull( application.cbController ) ) {
			application.cbController.getLoaderService().processShutdown();
		}
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );

		return true;
	}

	public function onRequestEnd(){
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );
	}

}
