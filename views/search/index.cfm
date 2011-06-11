<cfoutput>
	<div>
		<form action="#event.buildLink(prc.xehSearch)#" method="post">
			<input type="text" name="searchString">
			<input type="submit" value="search">
		</form>
	</div>
	<div>
		Current API: #prc.API#
	</div>
	<div>
		Avialable APIs:
		<ul>
			<cfloop array="#prc.APIs#" index="API" >
				<li><a href="#event.buildLink(prc.xehSwitchAPI)#/api/#api#">#API#</a></li>
			</cfloop>
		</ul>
	<div>
		Welcome to CBQuickDocs. This site is a tool that helps you quickly look up documentation on
		ColdBox Platforms APIs methods and classes. To begin, just type a method or class in the left
		field above.
	</div>
</cfoutput>