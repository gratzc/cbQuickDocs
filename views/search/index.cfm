<cfoutput>
	<div>
		<form name="searchForm" id="searchForm" action="#event.buildLink(prc.xehSearch)#" method="post">
			<input type="text" name="searchString" id="searchString">
			<label for="methodNames">Search Method Names</label><input type="checkbox" name="methodNames" id="methodNames" checked="true" value="true" />
			<label for="classNames">Search Class Names</label><input type="checkbox" name="classNames" id="classNames" checked="true" value="true" />
			<input type="submit" id="submit" value="search">
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
				var mChecked = $('##methodNames').is(':checked');
				var cChecked = $('##classNames').is(':checked');
				if (mChecked || cChecked) {
					$.post($(this).attr("action"),$(this).serialize(),function(data){
						$("##results").html(data);
						$("a[rel='colorbox']").colorbox({transition:"elastic", width:"75%", height:"75%", opacity:"0.55", iframe: true});
					});
				} else {
					alert('You must check one of the available search types.');
				}
				return false;
			})
			$("##searchString").autocomplete({
				source: function(request, response) {
					$.ajax({
						url: "#event.buildLink(prc.xehSearchNames)#",
						dataType: "json",
						data: {
							term: request.term,
							methodNames: $('##methodNames').is(':checked'),
							classNames: $('##classNames').is(':checked')
						},
						success: function(data) {
							response(data);
						}
					});
        	},
				select: function(event,ui){
					$("##searchForm").submit();
				},
				minLength:2,
			});
		});
	</script>
</cfoutput>