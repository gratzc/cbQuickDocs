<div>
<cfif prc.results.recordcount LTE 0>
	<h3>Sorry, there is nothing pertaining to <em>"<cfoutput>#rc.searchString#</cfoutput>"</em> in this API</h3>
<cfelse>
	<cfoutput query="prc.results">
		<div>Method: <a href="#link#" class="api_link" rel="colorbox">#methodName#</a></div>
		<div>Class: #className#</div>
		<div>Path: #classPath#</div>
	</cfoutput>
</cfif>
</div>