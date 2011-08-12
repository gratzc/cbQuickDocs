/**
* The CBQuickDocs search event handler
*/
component{

	property name="APISearchService" inject;
	property name="CookieStorage" inject="coldbox:plugin:CookieStorage";

	function preHandler(event){
		var prc = event.getCollection(private=true);
		prc.defaultAPI = getModuleSettings('cbQuickDocs').settings.defaultAPI;
	}

	function index(event,rc,prc){
		event.setView("search/index");
	}

	function searchForm(event,rc,prc){

		//set the current API and the available APIs
		prc.api = CookieStorage.getVar("api","");
		if( !len(prc.api) ){
			setNextEvent("cbQuickDocs.search.switchAPI","api=#prc.defaultAPI#");
		}
		prc.APIs = APISearchService.getAvailableAPIs();

		//xeh
		prc.xehSearch = "cbQuickDocs.search.search";
		prc.xehSwitchAPI = "cbQuickDocs.search.switchAPI";
		prc.xehSearchNames = "cbQuickDocs.search.searchNames";

		return renderView('search/searchForm');
	}

	function search(event,rc,prc) cache="true" cacheTimeout="30"{
		//set the current API and the available APIs
		var api = CookieStorage.getVar("api",prc.defaultAPI);
		var searchMethodNames = event.getValue("methodNames",false);
		var searchClassNames = event.getValue("classNames",false);
		prc.results = APISearchService.search(api,rc.searchString,searchMethodNames,searchClassNames);
		prc.searchMethodNames = searchMethodNames;
		prc.searchClassNames = searchClassNames;
		event.renderData(data=renderView('search/search'));
	}

	function searchNames(event,rc,prc) cache="true" cacheTimeout="30"{
		var api = CookieStorage.getVar("api",prc.defaultAPI);
		var searchMethodNames = event.getValue("methodNames",false);
		var searchClassNames = event.getValue("classNames",false);
		var results = APISearchService.searchNames(api,rc.term,searchMethodNames,searchClassNames);
		event.renderData(type="JSON",data=results);
	}

	function switchAPI(event,rc,prc) {
		CookieStorage.setVar("api",rc.api);
		getPlugin("MessageBox").info("API set to #rc.api#");
		setNextEvent('cbQuickDocs.search.index');
	}

}