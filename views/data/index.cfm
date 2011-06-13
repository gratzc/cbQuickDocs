<cfoutput>
	<div>
		<form name="dataForm"id="dataForm" action="#event.buildLink(prc.xehConvertAPI)#" method="post">
			<label for="apiURL">API Base URL:</label><input type="text" name="apiURL">
			<input type="submit" id="btnSubmit" value="convert">
		</form>
	</div>
	<div>
		Current APIs:
		<ul>
			<cfloop array="#prc.APIs#" index="API" >
				<li>#API#</li>
			</cfloop>
		</ul>
	</div>
	<div>
		Enter the root URL of the API you which to create data in the quickdocs for.
		The conversion my take serveral minutes.
	</div>
	<script>
		$(document).ready(function(){
			//Prevent double form submission.
			$("##dataForm").submit(function() {
				$("##btnSubmit").val("converting...");
				$("##btnSubmit").attr('disabled', 'disabled');
				return true;
			})
		});
	</script>
</cfoutput>