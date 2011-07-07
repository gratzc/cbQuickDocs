<div class="searchResults">
<cfif prc.results.recordcount LTE 0>
	<h3>Sorry, there is nothing pertaining to <em>"<cfoutput>#rc.searchString#</cfoutput>"</em> in this API</h3>
<cfelseif prc.results.recordcount EQ 1>
	<cfoutput>
		<iframe src="#prc.results.link#" width="100%" height="100%"></iframe>
	</cfoutput>
<cfelse>
	<table class="tablelisting">
		<tr>
			<th>Method:</th>
			<th>Class:</th>
			<th>Path:</th>
		</tr>
		<cfoutput query="prc.results" group="className">
		<cfif type EQ "Method">
			<cfoutput>
				<tr>
					<td><a href="#link#" class="api_link" rel="colorbox">#methodName#</a></td>
					<td><a href="#classLink#" class="api_link" rel="colorbox">#className#</a></td>
					<td>#classPath#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td>N/A</td>
				<td><a href="#classLink#" class="api_link" rel="colorbox">#className#</a></td>
				<td>#classPath#</td>
			</tr>
		</cfif>
		</cfoutput>
	</table>
</cfif>
</div>