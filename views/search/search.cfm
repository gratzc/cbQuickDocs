<div>
<cfif prc.results.recordcount LTE 0>
	<h3>Sorry, there is nothing pertaining to <em>"<cfoutput>#rc.searchString#</cfoutput>"</em> in this API</h3>
<cfelseif prc.results.recordcount EQ 1>
	<cfoutput>
		<iframe src="#prc.results.link#" width="100%" height="100%"></iframe>
	</cfoutput>
<cfelse>
	<cfoutput query="prc.results" group="className">
		<cfif type EQ "Method">
			<cfoutput>
				<div>Method: <a href="#link#" class="api_link" rel="colorbox">#methodName#</a></div>
				<div>Class: <a href="#listFirst(link,"##")#" class="api_link" rel="colorbox">#className#</a></div>
				<div>Path: #classPath#</div>
			</cfoutput>
		<cfelse>
			<div>Class: <a href="#listFirst(link,"##")#" class="api_link" rel="colorbox">#className#</a></div>
			<div>Path: #classPath#</div>
		</cfif>
	</cfoutput>
</cfif>
</div>