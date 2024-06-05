<cfoutput>
	<h1>Embedded</h1>

	<h1 x-data="{ message: 'I ❤️ Alpine' }" x-text="message"></h1>

</cfoutput>
<script>
	fetch('/api')
		.then(response => response.json())
		.then(json => console.log(json))
</script>
