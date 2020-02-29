public class Part_DetailController {
    public BOATBUILDING__Part__c objPart { get; set; }
    public Part_DetailController(){
        objPart = [SELECT Id, BOATBUILDING__Part_Number__c,Name,BOATBUILDING__Part__r.Name,BOATBUILDING__Vendor_Name__r.Name,
                   BOATBUILDING__Location__c,BOATBUILDING__Bin__c,	BOATBUILDING__Category1__c,
                   BOATBUILDING__Minimum_Amount__c,BOATBUILDING__Family1__c,Sub_Family__c,BOATBUILDING__Part_Size__c,
                   BOATBUILDING__Taxable__c,BOATBUILDING__Retail_Price__c,BOATBUILDING__Map_Price__c,	
                   BOATBUILDING__Discount__c,BOATBUILDING__Dealer_Price__c,BOATBUILDING__Part_Color__c,
                   BOATBUILDING__Part_Cost__c,BOATBUILDING__Weight__c,BOATBUILDING__Shopify_Product_Id__c,
                   BOATBUILDING__SKU__c,BOATBUILDING__Store_Location__c,BOATBUILDING__This_is_a_Physical_Product__c,
                   BOATBUILDING__Web_Description__c,BOATBUILDING__Web_Description_long__c,BOATBUILDING__Web_Part_Number__c,
                   BOATBUILDING__Web_Price__c,BOATBUILDING__Web_Product_Name__c,BOATBUILDING__WooCommerce_Id__c,BOATBUILDING__Barcode__c
                   FROM BOATBUILDING__Part__c 
                   WHERE Id =: ApexPages.currentPage().getParameters().get('Id')];
    }
    public PageReference updatePartDetail(){
        System.debug('Debug Log For objPart.Bin__c: '+objPart.Bin__c);
        update objPart;
        return null;
        //return new PageReference('/apex/Part_Detail?id='+objPart.Id);
    }
}