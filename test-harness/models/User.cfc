component persistent="true" table="users" {

	property
		name="user_id"
		fieldType="id"
		generator="uuid"
		setter="false";

	property
		name="firstName"
		notnull="true";

	property
		name="lastName"
		notnull="true";

	property
		name="userName"
		notnull="true";

	property
		name="password"
		notnull="true";

	property name="lastLogin" ormtype="date";

	property name="isActive" ormtype="bolean";

	// M20 -> Role
	property
		name     ="role"
		cfc      ="Role"
		fieldtype="many-to-one"
		fkcolumn ="FKRoleID"
		lazy     ="true"
		notnull  ="false";
}