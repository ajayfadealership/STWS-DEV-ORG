public class GooglePlaceController {
    @AuraEnabled
	public static string getSuggestions(String input) {
	    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + EncodingUtil.urlEncode(input, 'UTF-8')
	            + GooglePlaceController.getKey();
	    String response = GooglePlaceController.getResponse(url);
	    return response;
        

	}
    @AuraEnabled
        public static string getPlaceDetails(String placeId) {
            String url = 'https://maps.googleapis.com/maps/api/place/details/json?'
                    + 'placeid=' + EncodingUtil.urlEncode(placeId, 'UTF-8')
                    + GooglePlaceController.getKey(); 
            String response = GooglePlaceController.getResponse(url);
            return response;
        }
     
        public static string getResponse(string strURL){
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setMethod('GET');
            req.setEndpoint(strURL);
            req.setTimeout(120000);
            res = h.send(req); 
            String responseBody = res.getBody(); 
            return responseBody;
        }
     
        public static string getKey(){
            string key = 'AIzaSyAgAMYYBD6v-BgsoQum2tTKpjtvlfO3ZwY';
            string output = '&key=' + key;	 
            return output;
        }

}