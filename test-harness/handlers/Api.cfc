component extends="coldbox.system.RestHandler"{

	any function index( event, rc, prc ){
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
		sleep( randRange(100,2000 ) );
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
	}

}
