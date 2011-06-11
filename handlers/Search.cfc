/**
* The CBQuickDocs search event handler
*/
component{

	function index(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		prc.xehSearch = "cbQuickDocs.search.search";
		prc.api = "ColdboxDocs-3.0.0";
		//getModel('APIDataConvertorService').convert("http://coldbox.org/documents/api/ColdBoxDocs-3.0.0");
	}

	function search(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		prc.api = "ColdboxDocs-3.0.0";
		var r = getModel('APISearchService').search(prc.api,rc.searchString);
		writeDump(r);
		abort;
	}

}