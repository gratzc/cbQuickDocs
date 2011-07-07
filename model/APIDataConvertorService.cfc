<cfcomponent hint="I provide tools to take an API website and convert the data to cbQuickDocs usable data" output="false" singleton="true">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<!---dependencies--->
	<cfproperty name="PlainTextConvertor" inject="coldbox:myPlugin:PlainTextConvertor@cbquickdocs">
	<cfproperty name="cache" inject="coldbox:cacheManager">

	<!--- set a long request timeout as this takes a while --->
	<cfsetting requestTimeout="36000" />

	<cffunction name="init" access="public" returntype="APIDataConvertorService" output="false" hint="constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="convert" access="public" output="false" hint="I take a give API URL and gather all the data for cbQuickDocs to use and persist the data to disk">
		<cfargument name="apiURL" type="string" required="true" hint="The URL to the API to convert data for">
		<!--- Call to the allclasses-frame to get a list of classes and links to them to build our data off of --->
		<cfset var apiAllClassesURL = arguments.apiURL & "/allclasses-frame.html" />
		<cfhttp url="#apiAllClassesURL#" method="get" resolveurl="true" />
		<cfset var aClassLinks = getClassLinks(cfhttp.fileContent) />
		<cfset var methods = getMethods(aClassLinks) />
		<cfset var apiName = listLast(arguments.apiURL,"/") />
		<cfset var dir = getDirectoryFromPath(getCurrentTemplatePath()) & "data/" />
		<cfif not directoryExists(dir)>
			<cfdirectory action="create" directory="#dir#" />
		</cfif>
		<cfset var filePath = dir & apiName & ".json" />
		<!--- clear the cache for this api --->
		<cfset var apicacheKey = "cbquickdocs_" & apiName />
		<cfset cache.clear('cbquickdocs_AvailableAPIs') />
		<cfset cache.clear(apicacheKey) />
		<cffile action="write" file="#filePath#" output="#serializeJSON(methods)#" />
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="getClassLinks" access="private" returntype="Array" output="false" hint="I return an array of links to the different classes within an API">
		<cfargument name="AllClassesHTML" type="string" required="true" hint="The HTML from the AllClasses call to the API">
		<cfscript>
			//use REGEX to get an array of all the links from the HTML
			var aLinks = ReMatchNoCase('((((https?:|ftp:)\/\/)|(www\.|ftp\.))[-[:alnum:]\?$%,\.\/\|&##!@:=\+~_]+[A-Za-z0-9\/])', arguments.AllClassesHTML);
			//Remove the first to links that don't go to class pages
			arrayDeleteAt(aLinks,1);
			arrayDeleteAt(aLinks,1);

			return aLinks;
		</cfscript>
	</cffunction>

	<cffunction name="getMethods" access="private" returntype="Array" output="false" hint="I return an array of structs for each method in the API">
		<cfargument name="aClassLinks" type="array" required="true" hint="An array of links to the different API classes">
		<cfset var c = 0 />
		<cfset var methods = [] />
		<cfset var Link = "" />
		<cfloop array="#arguments.aClassLinks#" index="Link" >
			<cfset c = c + 1 />
			<cfhttp url="#Link#" method="get" resolveurl="true" />
			<cfscript>
				//use regex to pull all the links off this class page
				var methodLinks = ReMatchNoCase('((((https?:|ftp:)\/\/)|(www\.|ftp\.))[-[:alnum:]\?$%,\.\/\|&##!@:=\+~_]+[A-Za-z0-9\/])', cfhttp.fileContent);
				var methodLink = "";
				//get the base path
				var classPath = getBaseClassPath(cfhttp.fileContent);
				//get the className from the link
				var className = listLast(link,"/");
				className = listFirst(className,".");
				classPath = classPath & "." & className;
				//loop over all the links and find the method links
				for(methodLink in methodLinks){
					//if its an inpage link, then its a method
					if(find("##",methodLink)) {
						var methodName = listLast(methodLink,"##");
						methodLink = methodLink & "()";
						//ignore init and skip top
						if(methodName NEQ "init" and methodName NEQ "skip-navbar_top") {
							//add the method to our list of methods for this API and collect its meta data
							var method = {link=methodLink,methodName=methodName,classPath=classPath,className=className,classLink=link};
							arrayAppend(methods,method);
						}
					}
				}
			</cfscript>
			<!---<cfif c GTE 5>
				<cfbreak>
			</cfif>--->
		</cfloop>
		<cfreturn methods />
	</cffunction>

	<cffunction name="getBaseClassPath" access="private" returntype="String" output="false" hint="I return the classPath for a class from the HTML">
		<cfargument name="ClassHTML" type="string" required="true" hint="The HTML from the call to the API Class">
		<cfscript>
			//strip all the html
			var pt = PlainTextConvertor.convert(arguments.ClassHTML);
			//use regex to find the class path in the string
			var classPath = ReMatchNoCase('FRAMES.*?(?=$|\sClass)',pt);
			if (arrayLen(classPath)) {
				classPath = trim(listLast(classPath[1]," "));
			} else {
				classPath = 'Unknown';
			}
			return classPath;
		</cfscript>
	</cffunction>
</cfcomponent>
