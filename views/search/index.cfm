<cfoutput>
	<div class="search">
		<form name="searchForm" id="searchForm" action="#event.buildLink(prc.xehSearch)#" method="post">
			<label>
				<span>
				<!---<input type="text" name="searchString">--->
				<!---<input type="submit" value="search">--->
					<input name="searchString" type="text" class="keywords" id="textfield" maxlength="50" value="Search..." onclick="if(this.value=='Search...'){this.value=''}">
				</span>
				<input name="b" type="image" src="<cfoutput>#event.getModuleRoot()#</cfoutput>/includes/images/search.gif" class="button">
			</label>
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