@RestResource(urlMapping = '/productDlt/*')
global class RefreshWebProductId {
    @HttpGet
	global static String doGet() {
	    return 'Hey There';
	}
	
	@HttpPost
	global static void doPost() {
		RestRequest req = RestContext.request;
	    RestResponse res = RestContext.response;
		System.debug('>>>>req: '+req.requestBody.toString());
		System.debug('>>>>res: '+res);
		String body = req.requestBody.toString();
		String webProId = body.subString(body.indexOfIgnoreCase(':')+1,body.indexOfIgnoreCase('}'));
		System.debug('>>>>webProId: '+webProId);
		List<Part__c> lstPart = [SELECT Id, BOATBUILDING__Shopify_Product_Id__c, BOATBUILDING__WooCommerce_Id__c, 
										(Select Id, BOATBUILDING__WooCommerce_Id__c, BOATBUILDING__Shopify_Product_Id__c From Part_Variation__r) 
								FROM Part__c Where BOATBUILDING__Shopify_Product_Id__c =: webProId OR BOATBUILDING__WooCommerce_Id__c =: webProId];
		if(!lstPart.isEmpty()) {
			List<Part__c> lstPartVar = new List<Part__c>();
			for(Part__c objPart: lstPart) {
				if(String.isNotBlank(objPart.BOATBUILDING__Shopify_Product_Id__c) && objPart.BOATBUILDING__Shopify_Product_Id__c == webProId) {
					objPart.BOATBUILDING__Shopify_Product_Id__c = '';	
				}
				if(String.isNotBlank(objPart.BOATBUILDING__WooCommerce_Id__c) && objPart.BOATBUILDING__WooCommerce_Id__c == webProId) {
					objPart.BOATBUILDING__WooCommerce_Id__c = '';
				}
				if(!objPart.Part_Variation__r.isEmpty()) {
					for(Part__c objPartV: objPart.Part_Variation__r) { 
						if(String.isNotBlank(objPartV.BOATBUILDING__Shopify_Product_Id__c) && objPartV.BOATBUILDING__Shopify_Product_Id__c == webProId) {
							objPartV.BOATBUILDING__Shopify_Product_Id__c = '';	
						}
						if(String.isNotBlank(objPartV.BOATBUILDING__WooCommerce_Id__c) && objPartV.BOATBUILDING__WooCommerce_Id__c == webProId) {
							objPartV.BOATBUILDING__WooCommerce_Id__c = '';
						}
						lstPartVar.add(objPartV);
					}
				}
			}	
			update lstPart;
			System.debug('lstPart: '+lstPart);
			System.debug('lstPartVar: '+lstPartVar);
			if(!lstPartVar.isEmpty()) {
				update lstPartVar;
			}
		}
	}
}