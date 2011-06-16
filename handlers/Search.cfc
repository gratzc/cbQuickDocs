/**
* The CBQuickDocs search event handler
*/
component{
	
	property name="APISearchService" inject;
	property name="CookieStorage" inject="coldbox:plugin:CookieStorage";

	function index(event,rc,prc){

		//set the current API and the available APIs
		prc.api = CookieStorage.getVar("api","ColdboxDocs-3.0.0");
		prc.APIs = APISearchService.getAvailableAPIs();

		//xeh
		prc.xehSearch = "cbQuickDocs.search.search";
		prc.xehSwitchAPI = "cbQuickDocs.search.switchAPI";
	}

	function search(event,rc,prc){
		var api = CookieStorage.getVar("api","ColdboxDocs-3.0.0");
		prc.results = APISearchService.search(api,rc.searchString);
		event.renderData(data=renderView('search/search'));
	}

	function switchAPI(event,rc,prc) {
		CookieStorage.setVar("api",rc.api);
		getPlugin("MessageBox").info("API switched to #rc.api#");
		setNextEvent('cbQuickDocs.search.index');
	}

}