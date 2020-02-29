public with sharing class WorkOrderpageController {
    
    private final BOATBUILDING__Work_Order__c invent;
    public String batchResult{get;set;}
    
    public WorkOrderpageController(ApexPages.StandardController stdController){
        
        //batchResult = 'The batch has been started and it will flow work order into QB';
        this.invent = (BOATBUILDING__Work_Order__c)stdController.getRecord();
    }
    
    
    public pagereference sendworkordertoqb(){
     
        list<BOATBUILDING__Work_Order__c>lstBOATBUILDING = [SELECT Name,BOATBUILDING__Account__c,BOATBUILDING__Discount_on_Jobs__c,BOATBUILDING__Contact__c,BOATBUILDING__Description__c,BOATBUILDING__Discount__c,BOATBUILDING__Grand_Total__c,BOATBUILDING__isQBIDonContact__c,BOATBUILDING__Product__c,BOATBUILDING__QBInvoiceID__c,BOATBUILDING__QBInvoiceStatus__c,BOATBUILDING__Sales_Tax_Percent__c,BOATBUILDING__Sales_Tax__c,BOATBUILDING__Status__c,BOATBUILDING__Total_Amount_Due__c,BOATBUILDING__Total_Discount__c,BOATBUILDING__Total_Parts__c,BOATBUILDING__Total_Payment_job__c,BOATBUILDING__Total_Payment_payment__c,BOATBUILDING__Total_Shipping_Charges__c,BOATBUILDING__Total_Shop_Supplies__c,BOATBUILDING__Total__c, BOATBUILDING__SendInvoiceToQB__c FROM BOATBUILDING__Work_Order__c where Id = :ApexPages.currentPage().getParameters().get('id')]; 
        SendWorkOrderToQuickBookCtrl objSendWorkOrderToQuickBookCtrl = new SendWorkOrderToQuickBookCtrl();
        objSendWorkOrderToQuickBookCtrl.sendWOtoQB(lstBOATBUILDING);
        batchResult = 'The batch has been started and it will flow work order into QB';
        return null;
    }
}