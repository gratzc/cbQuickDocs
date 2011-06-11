/**
* The CBQuickDocs search event handler
*/
component{

	function index(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		//xeh
		prc.xehSearch = "cbQuickDocs.search.search";
		prc.xehSwitchAPI = "cbQuickDocs.search.switchAPI";
		prc.api = getPlugin("cookieStorage").getVar("api","ColdboxDocs-3.0.0");
		prc.APIs = getModel('APISearchService').getAvailableAPIs();
		//getModel('APIDataConvertorService').convert("http://coldbox.org/documents/api/ColdBoxDocs-3.0.0");
	}

	function search(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		var api = getPlugin("cookieStorage").getVar("api","ColdboxDocs-3.0.0");
		var r = getModel('APISearchService').search(api,rc.searchString);
		writeDump(r);
		abort;
	}

	function switchAPI(event) {
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		getPlugin("cookieStorage").setVar("api",rc.api);
		getPlugin("MessageBox").info("API switched to #rc.api#");
		setNextEvent('cbQuickDocs.search.index');
	}

}