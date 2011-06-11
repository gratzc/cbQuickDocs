/**
* The CBQuickDocs search event handler
*/
component{

	function index(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);

		//set the current API and the available APIs
		prc.api = getPlugin("cookieStorage").getVar("api","ColdboxDocs-3.0.0");
		prc.APIs = getModel('APISearchService').getAvailableAPIs();

		//xeh
		prc.xehSearch = "cbQuickDocs.search.search";
		prc.xehSwitchAPI = "cbQuickDocs.search.switchAPI";
	}

	function search(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		var api = getPlugin("cookieStorage").getVar("api","ColdboxDocs-3.0.0");
		prc.results = getModel('APISearchService').search(api,rc.searchString);
		return renderView('search/search');
	}

	function switchAPI(event) {
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		getPlugin("cookieStorage").setVar("api",rc.api);
		getPlugin("MessageBox").info("API switched to #rc.api#");
		setNextEvent('cbQuickDocs.search.index');
	}

}