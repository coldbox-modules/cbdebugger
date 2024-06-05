component extends="coldbox.system.RestHandler" profile{

	any function index( event, rc, prc ) profile {
		sleep( randRange(100,2000 ) );
		event.getResponse()
			.setData(
				getInstance( "MockData@MockDataCFC" )
					.mock(
						$num = "rnd:10:20",
						name = "name",
						id = "uuid",
						email = "email",
						biography = "lorem",
						createdDate = "datetime",
						updatedDate = "datetime",
						profileUrl = "imageURL"
					)
			);
	}

	any function person( event, rc, prc ){
		startCBTimer( "sleep" );
		cbTimeIt( "sleep", ()=>{
			sleep( randRange(100,2000 ) );

		},{
			"message" = "Sleeping"
		});
		event.getResponse()
			.setData(
				getInstance( "MockData@MockDataCFC" )
					.mock(
						$returnType = "struct",
						name = "name",
						id = "uuid",
						email = "email",
						biography = "lorem",
						createdDate = "datetime",
						updatedDate = "datetime",
						profileUrl = "imageURL"
					)
			);
			stopCBTimer( "sleep" );
	}

}
