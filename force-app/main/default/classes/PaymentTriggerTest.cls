@isTest
public class PaymentTriggerTest {
    private static testmethod void PaymentTriggerTest(){
        BOATBUILDING__TriggerSetting__c objSetting = new BOATBUILDING__TriggerSetting__c();
        objSetting.BOATBUILDING__ContactTriggerCheckbox__c = true;
        insert objSetting;
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        insert objInvoice;
        map<Id,BOATBUILDING__Payment__c> mappay = new map<Id,BOATBUILDING__Payment__c>();
        list<BOATBUILDING__Payment__c> lstpay = new list<BOATBUILDING__Payment__c>();
        BOATBUILDING__Payment__c objPay = new BOATBUILDING__Payment__c();
        objPay.BOATBUILDING__Related_to_Invoice__c = objInvoice.Id;
        mappay.put(objPay.Id,objPay);
        lstpay.add(objPay);
        insert objPay;
        PaymentTriggerHandler.onBeforeInsert(lstpay);
        PaymentTriggerHandler.onAfterInsert(lstpay);
        PaymentTriggerHandler.onAfterUpdate(lstpay,mappay);
        PaymentTriggerHandler.generatePaymentJson(objPay,'123acvygy3');
        
        
    }
    
}