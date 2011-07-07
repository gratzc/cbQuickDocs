<cfoutput>
	<div class="searchOptions">
		<div>
			<form name="searchForm" id="searchForm" action="#event.buildLink(prc.xehSearch)#" method="post">
				<label for="search">
					<span>
						<input name="searchString" type="text" class="keywords" id="searchString" maxlength="50" value="Search..." onclick="if(this.value=='Search...'){this.value=''}">
					</span>
					<input name="b" type="image" src="#event.getModuleRoot()#/includes/images/search.gif" class="button">
				</label>
				<label for="methodNames">Methods: <input type="checkbox" name="methodNames" id="methodNames" checked="true" value="true" /></label>
				<label for="classNames">Classes: <input type="checkbox" name="classNames" id="classNames" checked="true" value="true" /></label>
			</form>
		</div>
		<div>
			<form name="apiSelectionForm" id="apiSelectionForm" action="#event.buildLink(prc.xehSwitchAPI)#">
				<label for="apiNames">
					Available APIs:
					<select name="api" onChange="javascript: document.forms['apiSelectionForm'].submit()">
						<cfloop array="#prc.APIs#" index="API" >
						<option<cfif prc.API eq api> selected</cfif>>#API#</option>
						</cfloop>
					</select>
				</label>
			</form>
		</div>
		<div class="clr"></div>
	</div>
	<script>
		$(document).ready(function(){
			//ajax to submit the form and populate the results div
			$("##searchForm").submit(function() {
				$("##welcome").hide();

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