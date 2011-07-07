/**
* The CBQuickDocs search event handler
*/
component{

	property name="APISearchService" inject;
	property name="CookieStorage" inject="coldbox:plugin:CookieStorage";

	function index(event,rc,prc){

	}

	function searchForm(event,rc,prc){

		//set the current API and the available APIs
		prc.api = CookieStorage.getVar("api","");
		if (prc.api EQ "")
			setNextEvent("cbQuickDocs.search.switchAPI","api=ColdBoxDocs-3.1.0");
		prc.APIs = APISearchService.getAvailableAPIs();

		//xeh
		prc.xehSearch = "cbQuickDocs.search.search";
		prc.xehSwitchAPI = "cbQuickDocs.search.switchAPI";
		prc.xehSearchNames = "cbQuickDocs.search.searchNames";

		return renderView('search/searchForm');
	}

	function search(event,rc,prc){
		//set the current API and the available APIs
		var api = CookieStorage.getVar("api","ColdBoxDocs-3.1.0");
		var searchMethodNames = event.getValue("methodNames",false);
		var searchClassNames = event.getValue("classNames",false);
		prc.results = APISearchService.search(api,rc.searchString,searchMethodNames,searchClassNames);
		prc.searchMethodNames = searchMethodNames;
		prc.searchClassNames = searchClassNames;
		event.renderData(data=renderView('search/search'));
	}

	function searchNames(event,rc,prc){
		var api = CookieStorage.getVar("api","ColdBoxDocs-3.1.0");
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