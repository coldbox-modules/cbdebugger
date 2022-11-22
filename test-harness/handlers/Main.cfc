/**
 * My Event Handler Hint
 */
component {

	property name="qb"          inject="queryBuilder@qb";
	property name="roleService" inject="entityService:Role";
	property name="userService" inject="entityService:User";


	/**
	 * onRequestStart
	 */
	function onRequestStart( event, rc, prc ){
		prc.blogCategories = qb
			.newQuery()
			.from( "categories" )
			.orderBy( "category" )
			.get();

		prc.blogEntries = qb
			.newQuery()
			.from( "blogEntries" )
			.orderBy( "blogEntriesdateUpdated", "desc" )
			.get();

		prc.roles = variables.roleService.newCriteria().list();
	}

	// Index
	any function index( event, rc, prc ){
		getInstance( "TestService" ).testMethod();

		prc.blogEntries = qb
			.newQuery()
			.from( "blogEntries" )
			.orderBy( "blogEntriesdateUpdated", "desc" )
			.get();

		prc.blogEntry = qb
			.newQuery()
			.from( "blogEntries" )
			.where( "blogEntriesId", 1 )
			.get();

		prc.blogCategories = qb
			.newQuery()
			.from( "categories" )
			.orderBy( "category" )
			.get();

		prc.users = qb
			.newQuery()
			.from( "users" )
			.where( "isActive", true )
			.orderBy( "lastName" )
			.get();

		prc.ormUsers = variables.userService
			.newCriteria()
			.isTrue( "isActive" )
			.list( sortOrder = "lastName desc" );

		prc.totalUsers = variables.userService
			.newCriteria()
			.isTrue( "isActive" )
			.count();

		prc.currentUser = variables.userService
			.newCriteria()
			.isTrue( "isActive" )
			.isEq( "user_id", "88B73A03-FEFA-935D-AD8036E1B7954B76" )
			.get();

		prc.data = variables.userService.executeQuery(
			query: "
				select new map( user_id as id, firstName as firstName, lastName as lastName, lastLogin as lastLogin )
				from User
				where isActive = :active and
				lastLogin >= :lastLogin
			",
			params: {
				"active"    : true,
				"lastLogin" : createDate( 2011, 01, 01 )
			}
		);

		prc.logs = getInstance( "Log" ).paginate( 1, 100 );
		log.info( "in the index event firing" );
	}

	function embedded( event, rc, prc ){
		event.setView( "main/embedded" ).setLayout( "Embedded" );
	}

	any function noDebugger( event, rc, prc ){
		hideDebugger();
		event.renderData( data = "<h1>Hello</h1>" );
	}

	/**
	 * error
	 */
	function error( event, rc, prc ){
		event.setdddView( "Main/error" );
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
		var logBox = controller.getLogBox();
		logBox.registerAppender( "tracer", "cbdebugger.appenders.TracerAppender" );
		var appenders = logBox.getAppendersMap( "tracer" );
		// Register the appender with the root loggger, and turn the logger on.
		var root      = logBox.getRootLogger();
		root.addAppender( appenders[ "tracer" ] );
		root.setLevelMax( 4 );
		root.setLevelMin( 0 );
	}

}
