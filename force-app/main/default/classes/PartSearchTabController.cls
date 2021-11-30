public with sharing class PartSearchTabController {
    @AuraEnabled
    public static List<PartSearchWrapper> searchPart(String partNo, String selected){
        try {
            List<PartSearchWrapper> lstPartWrapperAll = new List<PartSearchWrapper>();
            string searchKeyword = '%' + partNo + '%';
            List<PartSearchWrapper> lstPartWrapper = new List<PartSearchWrapper>();
            List<BOATBUILDING__Part__c> lstPart = new List<BOATBUILDING__Part__c>();
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstWOJLI = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            List<BOATBUILDING__Invoice_Line_Item__c> lstILI = new List<BOATBUILDING__Invoice_Line_Item__c>();
            List<BOATBUILDING__Line_Items__c> lstOrder = new List<BOATBUILDING__Line_Items__c>();
            Set<String> setPartNum = new Set<String>();
            lstPart = [SELECT Id, Name, BOATBUILDING__Part_Number__c FROM BOATBUILDING__Part__c 
            WHERE BOATBUILDING__Part_Number__c LIKE : searchKeyword];
            if(selected == 'workOrder' || selected == 'All'){
            lstWOJLI = [SELECT Id, BOATBUILDING__Part_Name__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c, BOATBUILDING__Price__c 
                            FROM BOATBUILDING__Work_Order_Job_Line_Item__c
                            WHERE BOATBUILDING__Part_Number__c LIKE : searchKeyword];

            
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objWorkOrderJLI : lstWOJLI){
                PartSearchWrapper objPartnerWrap = new PartSearchWrapper();
                objPartnerWrap.partName = objWorkOrderJLI.BOATBUILDING__Part_Name__c;
                objPartnerWrap.partNumber = objWorkOrderJLI.BOATBUILDING__Part_Number__c;
                objPartnerWrap.quantity = objWorkOrderJLI.BOATBUILDING__Quantity__c;
                objPartnerWrap.price = objWorkOrderJLI.BOATBUILDING__Price__c;
                objPartnerWrap.relatedTo = objWorkOrderJLI.Id;
                lstPartWrapper.add(objPartnerWrap);
                if(selected == 'All'){
                lstPartWrapperAll.add(objPartnerWrap);
                }
                System.debug('lstwrapper '+ lstPartWrapper);
            }
        }

            else if(selected == 'invoice' || selected == 'All'){
                lstILI = [SELECT Id,BOATBUILDING__Part_Cost__c,BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c, BOATBUILDING__Total_Price__c
                            FROM BOATBUILDING__Invoice_Line_Item__c 
                            WHERE BOATBUILDING__Part_Number__c LIKE : searchKeyword];
            
            for(BOATBUILDING__Invoice_Line_Item__c objInv : lstILI){
                PartSearchWrapper objPartnerWrap = new PartSearchWrapper();
                objPartnerWrap.partCost = objInv.BOATBUILDING__Part_Cost__c;
                objPartnerWrap.partNumber1 = objInv.BOATBUILDING__Part_Number__c;
                objPartnerWrap.quantity1 = objInv.BOATBUILDING__Quantity__c;
                objPartnerWrap.totalPrice = objInv.BOATBUILDING__Total_Price__c;
                objPartnerWrap.relatedTo = objInv.Id;
                lstPartWrapper.add(objPartnerWrap);
                if(selected == 'All'){
                lstPartWrapperAll.add(objPartnerWrap);
                }
                System.debug('lstwrapper '+ lstPartWrapper);
            }
        }
            else if(selected == 'order' || selected == 'All'){
                lstOrder = [SELECT Id, BOATBUILDING__Part_Number_del__c, RecordType.Name, BOATBUILDING__Amount__c, BOATBUILDING__Cost__c, BOATBUILDING__Name__c
                             FROM BOATBUILDING__Line_Items__c 
                            WHERE BOATBUILDING__Part_Number_del__c LIKE : searchKeyword and RecordType.Name =: 'Order'];
                for(BOATBUILDING__Line_Items__c objLineItem : lstOrder){
                    setPartNum.add(objLineItem.BOATBUILDING__Part_Number_del__c);
                }
                List<BOATBUILDING__Part__c> lstParts = [SELECT Id, Name, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Size__c
                                                            FROM BOATBUILDING__Part__c WHERE BOATBUILDING__Part_Number__c IN : setPartNum];
                for(BOATBUILDING__Part__c objPart : lstParts){
                    PartSearchWrapper objPartnerWrap = new PartSearchWrapper();
                    objPartnerWrap.partCost1 = objPart.BOATBUILDING__Part_Cost__c;
                    objPartnerWrap.partNumber3 = objPart.BOATBUILDING__Part_Number__c;
                    objPartnerWrap.partSize = objPart.BOATBUILDING__Part_Size__c;
                    objPartnerWrap.name = objPart.Name;
                    objPartnerWrap.relatedTo = objPart.Id;
                    lstPartWrapper.add(objPartnerWrap);
                    if(selected == 'All'){
                    lstPartWrapperAll.add(objPartnerWrap);
                    }
                    System.debug('lstwrapper '+ lstPartWrapper);
                }
                
            }

            else if(selected == 'purchaseOrder' || selected == 'All'){
                lstOrder = [SELECT Id, BOATBUILDING__Part_Number_del__c, RecordType.Name, BOATBUILDING__Amount__c, BOATBUILDING__Cost__c, BOATBUILDING__Name__c
                             FROM BOATBUILDING__Line_Items__c 
                            WHERE BOATBUILDING__Part_Number_del__c LIKE : searchKeyword and RecordType.Name =: 'Purchase_Order'];
                for(BOATBUILDING__Line_Items__c objLineItem : lstOrder){
                    setPartNum.add(objLineItem.BOATBUILDING__Part_Number_del__c);
                }
                List<BOATBUILDING__Part__c> lstParts = [SELECT Id, Name, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Size__c
                                                            FROM BOATBUILDING__Part__c WHERE BOATBUILDING__Part_Number__c IN : setPartNum];
                for(BOATBUILDING__Part__c objPart : lstParts){
                    PartSearchWrapper objPartnerWrap = new PartSearchWrapper();
                    objPartnerWrap.partCost1 = objPart.BOATBUILDING__Part_Cost__c;
                    objPartnerWrap.partNumber3 = objPart.BOATBUILDING__Part_Number__c;
                    objPartnerWrap.partSize = objPart.BOATBUILDING__Part_Size__c;
                    objPartnerWrap.name = objPart.Name;
                    objPartnerWrap.relatedTo = objPart.Id;
                    lstPartWrapper.add(objPartnerWrap);
                    if(selected == 'All'){
                    lstPartWrapperAll.add(objPartnerWrap);
                    }
                    System.debug('lstwrapper '+ lstPartWrapper);
                }
                
            }
            
            return lstPartWrapper;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public Class PartSearchWrapper{
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String partName {get; set;}
        @AuraEnabled
        public String partNumber {get; set;}
        @AuraEnabled
        public String partNumber1 {get; set;}
        @AuraEnabled
        public Decimal quantity {get; set;}
        @AuraEnabled
        public Decimal quantity1 {get; set;}
        @AuraEnabled
        public Decimal price {get; set;}
        @AuraEnabled
        public Decimal partCost {get; set;}
        @AuraEnabled
        public Decimal totalPrice {get; set;}
        @AuraEnabled
        public String amount {get; set;}
        @AuraEnabled
        public String cost {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String partSize {get; set;}
        @AuraEnabled
        public Decimal partCost1 {get; set;}
        @AuraEnabled
        public String partNumber3 {get; set;}
        @AuraEnabled
        public String relatedTo {get; set;}
    }
}