public class CreateDealerQuoteController {
    @AuraEnabled
    public static String generateDealerQuoteApex(String strQuoteId) {
        Id recordTypeId = Schema.SObjectType.BOATBUILDING__Quote__c.getRecordTypeInfosByDeveloperName().get('Dealer_Quote').getRecordTypeId();
        String soql = getCreatableFieldsSOQL('BOATBUILDING__Quote__c','Id = \''+strQuoteId+'\'');
        BOATBUILDING__Quote__c objMainQuote = (BOATBUILDING__Quote__c)Database.query(soql);
        BOATBUILDING__Quote__c objDlrQuote = objMainQuote.clone(false, true);
        if(objMainQuote.BOATBUILDING__Dealer_Quote__c != null) {
            objDlrQuote.Id = objMainQuote.BOATBUILDING__Dealer_Quote__c;
            objDlrQuote.BOATBUILDING__Dealer_Quote__c = null;
        }  
        objDlrQuote.RecordTypeId = recordTypeId;
        upsert objDlrQuote; 
        if(objMainQuote.BOATBUILDING__Dealer_Quote__c == null) {
            objMainQuote.BOATBUILDING__Dealer_Quote__c = objDlrQuote.Id;
            update objMainQuote;
        }
        String soql_LI = getCreatableFieldsSOQL('BOATBUILDING__Quote_Line_Item__c','BOATBUILDING__Quote__c = \''+strQuoteId+'\'');        
        List<BOATBUILDING__Quote_Line_Item__c> lstMainQLI = (List<BOATBUILDING__Quote_Line_Item__c>)Database.query(soql_LI);
        delete [Select Id From BOATBUILDING__Quote_Line_Item__c Where BOATBUILDING__Quote__c =: objDlrQuote.Id];
        List<BOATBUILDING__Quote_Line_Item__c> lstQuoteLineItem = new List<BOATBUILDING__Quote_Line_Item__c>();
        for(BOATBUILDING__Quote_Line_Item__c objQLI: lstMainQLI) {
            BOATBUILDING__Quote_Line_Item__c objQLID = new BOATBUILDING__Quote_Line_Item__c();
            objQLID.Name = 'QLI';
            objQLID.Name__c = objQLI.Name__c;
            objQLID.Product__c = objQLI.Product__c;
            objQLID.Option_Category__c = objQLI.Option_Category__c;
            objQLID.Total_Price__c = objQLI.Total_Price__c;
            objQLID.Date__c =  objQLI.Date__c;
            objQLID.Dealer_Price__c = objQLI.Dealer_Price__c;
            objQLID.Product_Code__c = objQLI.Product_Code__c ;
            objQLID.BOATBUILDING__Quote__c = objDlrQuote.Id;
            objQLID.Non_Taxable__c = objQLI.Non_Taxable__c;
            lstQuoteLineItem.add(objQLID); 
        }
        insert lstQuoteLineItem; 
        return objDlrQuote.Id;
    }
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        
        String selects = '';
        
        if (whereClause == null || whereClause == ''){ return null; }
        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
            
        }
        
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        
    }
}