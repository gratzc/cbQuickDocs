/**
* I handle data related events
*/
component{

	function index(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		prc.xehConvertAPI = "cbquickdocs.data.convertAPI";
		prc.APIs = getModel('APISearchService').getAvailableAPIs();
	}	function convertAPI(event){
		var rc = event.getCollection();

		getModel('APIDataConvertorService').convert(rc.apiURL);

		getPlugin("MessageBox").info("#rc.apiURL# has been converted and can now be used");
		setNextEvent('cbquickdocs.data.index');
	}

}
