<cfcomponent hint="I provide the utility for searching through the APIs" output="false" singleton="true">

	<!---dependencies--->
	<cfproperty name="cache" inject="coldbox:cacheManager">
	<cfproperty name="queryHelper" inject="coldbox:plugin:QueryHelper">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="APISearchService" output="false" hint="constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="search" access="public" returntype="Query" output="false" hint="Search the API with the search string and return the results">
		<cfargument name="API" required="true" hint="The API to search">
		<cfargument name="searchString" required="true" hint="The string to search on">
		<cfargument name="searchMethodNames" required="true" hint="The string to search on">
		<cfargument name="searchClassNames" required="true" hint="The string to search on">
		<cfscript>
			var cacheKey = "cbquickdocs_" & arguments.API;
			//check to see if the API is already cached
			if(cache.lookup(cacheKey)) {
				var qryAllApi = cache.get(cacheKey);
			} else {
				var fileName = arguments.API & ".json";
				var filePath = getDirectoryFromPath(getCurrentTemplatePath()) & "data/" & fileName;
				var data = fileRead(filePath);
				data = deserializeJSON(data);
				var qryAllApi = queryHelper.arrayOfStructuresToQuery(data);
				cache.set(cacheKey,qryAllApi);
			}
			var searchresults = queryNew("new");
			var classresults = queryNew("new");
			var methodresults = queryNew("new");
		</cfscript>
		<cfif searchMethodNames>
			<cfquery name="methodresults" dbtype="query">
				select methodName, className, classPath, classLink, link, 'method' as type from qryAllApi
				where
					LOWER(methodName) like <cfqueryparam value="%#lcase(searchString)#%" >
			</cfquery>
			<cfset searchresults = methodresults>
		</cfif>
		<cfif searchClassNames>
			<cfquery name="classresults" dbtype="query">
				select methodName, className, classPath, classLink, link, 'class' as type from qryAllApi
				where
					LOWER(className) like <cfqueryparam value="%#lcase(searchString)#%" >
			</cfquery>
			<cfset searchresults = classresults>
		</cfif>
		<cfif searchMethodNames and searchClassNames>
			<cfset searchresults = queryHelper.doQueryAppend(methodresults,classresults)>
		</cfif>
		<cfreturn searchresults />
	</cffunction>

	<cffunction name="searchNames" access="public" returnType="Array" output="false" hint="I return an array of names from a searchString based on the api">
		<cfargument name="API" required="true" hint="The API to search">
		<cfargument name="searchString" required="true" hint="The string to search on">
		<cfargument name="searchMethodNames" required="true" hint="The string to search on">
		<cfargument name="searchClassNames" required="true" hint="The string to search on">
		<!--- get all the results based on the searchString --->
		<cfset var results = search(API,searchString,searchMethodNames,searchClassNames) />
		<cfset var classresults = queryNew("new") />
		<cfset var methodresults = queryNew("new") />
		<cfset var max = 10 />
		<cfif searchMethodNames and searchClassNames>
			<cfset max = 5 />
		</cfif>
		<!--- get the top 10 unqiue class names  --->
		<cfquery name="classNames" dbtype="query" maxrows="#max#">
			select distinct className from results where type='class'
		</cfquery>
		<!--- get the top 10 unqiue method names  --->
		<cfquery name="methodNames" dbtype="query" maxrows="#max#">
			select distinct methodName from results where type='method'
		</cfquery>
		<!--- combine the results --->
		<cfset var data = [] />
		<cfset var arClassNames = listToArray(valueList(classNames.className)) />
		<cfset var arMethodNames = listToArray(valueList(methodNames.methodName)) />
		<cfset data.addAll(arClassNames) />
		<cfset data.addAll(arMethodNames) />
		<cfreturn data />
	</cffunction>

	<cffunction name="getAvailableAPIs" access="public" returntype="Array" output="false" hint="Return an array of the avaiable APIs in the system">
		<cfset var arrayAPIs = [] />
		<cfset var cacheKey = "cbquickdocs_AvailableAPIs" />
		<!--- check to see if the cache already has our available apis, if it does, use that, otherwise get them --->
		<cfif (cache.lookup(cacheKey))>
			<cfset arrayAPIs = cache.get(cacheKey) />
		<cfelse>
			<cfset var dir = getDirectoryFromPath(getCurrentTemplatePath()) & "data/" />
			<cfdirectory action="list" directory="#dir#" name="APIs" />
			<cfset var arrayAPIs = [] />
			<cfoutput query="APIs">
				<cfset arrayAppend(arrayAPIs,left(name,len(name)-5)) />
			</cfoutput>
			<cfset cache.set(cacheKey,arrayAPIs) />
		</cfif>
		<cfreturn arrayAPIs />
	</cffunction>

</cfcomponent>
