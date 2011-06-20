<cfcomponent hint="I provide the utility for searching through the APIs" output="false" singleton="true">
	<!---dependencies--->
	<cfproperty name="cache" inject="coldbox:cacheManager">
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
		<cfscript>
			var cacheKey = "cbquickdocs_" & arguments.API;
			//var cache = OCM.getDefaultCache();
			//check to see if the API is already cached
			if(cache.lookup(cacheKey)) {
				var qryAllApi = cache.get(cacheKey);
			} else {
				var fileName = arguments.API & ".json";
				var filePath = getDirectoryFromPath(getCurrentTemplatePath()) & "data/" & fileName;
				var data = fileRead(filePath);
				data = deserializeJSON(data);
				var qryAllApi = arrayOfStructuresToQuery(data);
				cache.set(cacheKey,qryAllApi);
			}
			var searchresults = queryNew("new");
		</cfscript>
		<cfquery name="searchresults" dbtype="query">
			select * from qryAllApi
			where
				LOWER(methodName) like <cfqueryparam value="%#lcase(searchString)#%" > or
				LOWER(className) like <cfqueryparam value="%#lcase(searchString)#%" > or
				LOWER(classPath) like <cfqueryparam value="%#lcase(searchString)#%" >
		</cfquery>
		<cfreturn searchresults />
	</cffunction>

	<cffunction name="getAvailableAPIs" access="public" returntype="Array" output="false" hint="Return an array of the avaiable APIs in the system">
		<cfset var arrayAPIs = [] />
		<cfset var cacheKey = "cbquickdocs_AvailableAPIs" />
		<!---<cfset var cache = OCM.getDefaultCache() />--->
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

	<cfscript>
		/**
		* Converts an array of structures to a CF Query Object.
		* 6-19-02: Minor revision by Rob Brooks-Bilson (rbils@amkor.com)
		*
		* Update to handle empty array passed in. Mod by Nathan Dintenfass. Also no longer using list func.
		*
		* @param Array      The array of structures to be converted to a query object. Assumes each array element contains structure with same (Required)
		* @return Returns a query object.
		* @author David Crawford (rbils@amkor.comdcrawford@acteksoft.com)
		* @version 2, March 19, 2003
		*/
		function arrayOfStructuresToQuery(theArray){
			var colNames = "";
			var theQuery = queryNew("");
			var i=0;
			var j=0;
			//if there's nothing in the array, return the empty query
			if(NOT arrayLen(theArray))
				return theQuery;
			//get the column names into an array =
			colNames = structKeyArray(theArray[1]);
			//build the query based on the colNames
			theQuery = queryNew(arrayToList(colNames));
			//add the right number of rows to the query
			queryAddRow(theQuery, arrayLen(theArray));
			//for each element in the array, loop through the columns, populating the query
			for(i=1; i LTE arrayLen(theArray); i=i+1){
				for(j=1; j LTE arrayLen(colNames); j=j+1){
					if (isDate(theArray[i][colNames[j]]) and (theArray[i][colNames[j]]) eq "1900-01-01 00:00:00.0") {
						theArray[i][colNames[j]] = "";
					}
					querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
				}
			}
			return theQuery;
		}
	</cfscript>
</cfcomponent>
