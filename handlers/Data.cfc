/**
* I handle data related events
*/
component{

	property name="APISearchService" 		inject;
	property name="APIDataConvertorService" inject;


	function index(event,rc,prc){
		prc.xehConvertAPI = "cbquickdocs.data.convertAPI";
		prc.APIs = APISearchService.getAvailableAPIs();
	}	function convertAPI(event,rc,prc){
		
		APIDataConvertorService.convert(rc.apiURL);

		getPlugin("MessageBox").info("#rc.apiURL# has been converted and can now be used");
		
		setNextEvent('cbquickdocs.data.index');
	}

}
