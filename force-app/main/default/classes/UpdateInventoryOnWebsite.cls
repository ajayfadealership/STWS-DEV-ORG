global class UpdateInventoryOnWebsite {
    
    webservice static string updateOnWeb(String invId){
        return updateOnWebLightning(invId);
    }
    
    @AuraEnabled
    public static string updateOnWebLightning(String invId){
        Inventory__c objInv = [Select Name, BOATBUILDING__Refresh_Images_on_Website__c, BOATBUILDING__Store_Location__c from Inventory__c where Id =: invId];
        String strResponse = '';
        Boolean imagesUpdated = objInv.BOATBUILDING__Refresh_Images_on_Website__c;
        try{
            
            //BOATBUILDING__FroceDotCom__c.getOrgDefaults().BOATBUILDING__WebsiteEndPoint__c;
            Map<String, BOATBUILDING__SalesTaxConfiguration__c> mapSL = BOATBUILDING__SalesTaxConfiguration__c.getAll();
            for(BOATBUILDING__SalesTaxConfiguration__c objSTC : mapSL.values()){
                String strEndpoint;
                if(STRING.isNotblank(objSTC.BOATBUILDING__Website_Endpoint_URL__c))
                    strEndpoint = objSTC.BOATBUILDING__Website_Endpoint_URL__c;
                
                if(String.isNotBlank(strEndpoint)){
                    //Inventory__c objInv = [Select Name, BOATBUILDING__Store_Location__c from Inventory__c where Id =: invId];
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(strEndpoint+'?wpsfp-ajax=update_product&product_id='+objInv.Name);
                    request.setMethod('GET');
                    request.setTimeout(120000);
                    Http http = new Http();
                    if(!Test.isRunningTest()){
                        //SendEmailUtility.sendQuickEmail('---request---'+request+'---Limits.getHeapSize()-1--'+Limits.getHeapSize());
                        HttpResponse response = http.send(request);
                        //SendEmailUtility.sendQuickEmail('---strResponse---'+strResponse+'---Limits.getHeapSize()-2--'+Limits.getHeapSize());
                        strResponse = response.getBody();
                        //SendEmailUtility.sendQuickEmail('---response.getBody()---'+response.getBody()+'---Limits.getHeapSize()-3--'+Limits.getHeapSize());
                    }
                }                
            }
            
            if(imagesUpdated){
                objInv.BOATBUILDING__Refresh_Images_on_Website__c = false;
                update objInv;
            }
            if(imagesUpdated){
                strResponse = 'The update request has been sent. Image update process may take few minutes.';
            }
            else{
                strResponse = 'The update request has been sent.';
            }
            return strResponse;
            
        }catch(Exception e){
            if(!imagesUpdated){
                objInv.BOATBUILDING__Refresh_Images_on_Website__c = true;
                update objInv; 
            }
            
            throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage()+'--'+e.getStackTraceString()); 
        }
    }
}