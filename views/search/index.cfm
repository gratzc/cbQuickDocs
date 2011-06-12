<cfoutput>
	<div>
		<form name="searchForm" id="searchForm" action="#event.buildLink(prc.xehSearch)#" method="post">
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
	</div>
	<div>
		Welcome to CBQuickDocs. This site is a tool that helps you quickly look up documentation on
		ColdBox Platforms APIs methods and classes. To begin, just type a method or class in the left
		field above.
	</div>
	<div id="results">
	</div>
	<script>
		$(document).ready(function(){
			//ajax to submit the form and populate the results div
			$("##searchForm").submit(function() {
				$.post($(this).attr("action"),$(this).serialize(),function(data){
					$("##results").html(data);
					$("a[rel='colorbox']").colorbox({transition:"elastic", width:"75%", height:"75%", opacity:"0.55", iframe: true});
				});
				return false;
			})
		});
	</script>
</cfoutput>