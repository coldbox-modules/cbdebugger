component
	extends="quick.models.BaseEntity"
	accessors="true"
	table="logs"
{

	property name="id";
    property name="severity";
    property name="category";
	property name="logdate";
	property name="appendername";
	property name="message";
	property name="extrainfo";

	function keyType() {
        return variables._wirebox.getInstance( "UUIDKeyType@quick" );
    }

}