/***************************
Created By: Pradeep Kumar
Date : 9th Sept 2017
Description :

***************************/

public class SendWorkOrderToQuickBookCtrl{
    public static String WOId;
    public static List<BOATBUILDING__Work_Order__c> LstWorkOrder;
    public SendWorkOrderToQuickBookCtrl(){
        
        /* WOId = ApexPages.currentPage().getParameters().get('Id');
LstWorkOrder = [SELECT BOATBUILDING__Account__c,BOATBUILDING__Contact__c,BOATBUILDING__Description__c,
BOATBUILDING__Discount__c,BOATBUILDING__Grand_Total__c,BOATBUILDING__isQBIDonContact__c,
BOATBUILDING__Product__c,BOATBUILDING__QBInvoiceID__c,BOATBUILDING__QBInvoiceStatus__c,
BOATBUILDING__Sales_Tax_Percent__c,BOATBUILDING__Sales_Tax__c,BOATBUILDING__SLA_Violation__c,
BOATBUILDING__Status__c,BOATBUILDING__SuppliedCompany__c,BOATBUILDING__SuppliedPhone1__c,
BOATBUILDING__Total_Amount_Due__c,BOATBUILDING__Total_Discount__c,BOATBUILDING__Total_Parts__c,
BOATBUILDING__Total_Payment_job__c,BOATBUILDING__Total_Payment_payment__c,BOATBUILDING__Total_Shipping_Charges__c,
BOATBUILDING__Total_Shop_Supplies__c,BOATBUILDING__Total__c 
FROM BOATBUILDING__Work_Order__c ];*/
        //updateAccountOnWorkOrder(LstWorkOrder);
        
    }
    
    public void sendWOtoQB(List<BOATBUILDING__Work_Order__c> LstWorkOrder){
        try{
            list<contact> conUpdatedLst = updateAccountOnWorkOrder(LstWorkOrder);
            createQBWorkOrder(LstWorkOrder,conUpdatedLst);
            update conUpdatedLst;
        }
        catch(exception e)
        {
            system.debug('Exception type caught: \n' + e.getTypeName()+'Message: \n' + e.getMessage()+'Line number: \n' + e.getLineNumber()+'Stack trace: \n' + e.getStackTraceString());
            //SendEmailUtility.sendEmail('Exception type caught: \n' + e.getTypeName()+'Message: \n' + e.getMessage()+'Line number: \n' + e.getLineNumber()+'Stack trace: \n' + e.getStackTraceString());
        }
    }
    
    public Static list<Contact> updateAccountOnWorkOrder(list<BOATBUILDING__Work_Order__c> lstWorkOrder){
        list<Contact> conUpdatedlst = new list<Contact>();
        Set<Id> setContactIds = new Set<Id>();
        for(BOATBUILDING__Work_Order__c objWO : lstWorkOrder){
            setContactIds.add(objWO.BOATBUILDING__Contact__c);
        }
        System.debug('==setContactIds=='+setContactIds);
        Map<id, id> mapContactToAccount = new Map<Id, Id>();
        for(Contact objCon : [SELECT id,AccountId,BOATBUILDING__QBCustomerID__c from Contact where ID IN : setContactIds]){
            mapContactToAccount.put(objCon.Id, objCon.AccountId);
            if(String.isBlank(objCon.BOATBUILDING__QBCustomerID__c)){//Code added by pradeep on 5th Sept17
                System.debug('==Enter in Check where QB id is Checked===');
                Contact conResponse = QbConnectUtil.FetchQBCustomer(objCon.id);//Code added by Pradeep on 19thAug17 modified on 5thSept17
                conUpdatedlst.add(conResponse);
            }
            else
            {
                conUpdatedlst.add(objCon);
            }
        }
        /*for(BOATBUILDING__Work_Order__c objWO : lstWorkOrder){
            objWO.BOATBUILDING__Account__c = mapContactToAccount.get(objWO.BOATBUILDING__Contact__c);
        }*/
        return conUpdatedlst;
    }
    
    public Static void createQBWorkOrder(list<Work_Order__c> lstWorkOrder,list<contact>conUpdatedLst){
        String payload;
        System.debug('===lstWO===' +lstWorkOrder[0].Contact__c);
        //SendEmailUtility.sendEmail('===lstWO===' +lstWorkOrder[0].Contact__c);
        Set<Id> conID = new Set<Id>();
        for(Work_Order__c objwo : lstWorkOrder){
            conID.add(objwo.Contact__c);
        }
        System.debug('===conID==='+conID);
        Map<id,Contact> mapCon = new Map<id,Contact>();
        for(Contact objCon :conUpdatedLst)
        {
            if(!mapCon.containskey(objCon.id))
                mapCon.put(objCon.id,objCon);
            
        }
        System.debug('===mapCon===='+mapCon);
        //SendEmailUtility.sendEmail('===mapCon===='+mapCon);
        
        for(Work_Order__c objwo: lstWorkOrder){
            //System.debug(objwo.BOATBUILDING__SendInvoiceToQB__c+'===Test=='+oldMapWorkOrder.get(objwo.id).BOATBUILDING__SendInvoiceToQB__c);
            //if(objwo.BOATBUILDING__isQBIDonContact__c && objwo.BOATBUILDING__SendInvoiceToQB__c && !oldMapWorkOrder.get(objwo.id).BOATBUILDING__SendInvoiceToQB__c){
            payload = generateWOJson(objwo, mapCon.get(objwo.Contact__c).QBCustomerID__c);
            System.debug('===PayloadTest=='+payload);
            QbConnectUtil.CreateQBWorkOrder(payload, objwo.id);
            //}
        }
        System.debug('====payload===='+payload);
        //SendEmailUtility.sendEmail('====payload===='+payload);
    }
    
    
    //This Method is used to create a JSON for Invoice
    public Static String generateWOJson(Work_Order__c objwo, String QBId){
        //System.debug('===objwo.BOATBUILDING__Discount_on_Jobs__c===' +objwo.BOATBUILDING__Discount_on_Jobs__c);
        Map<String, BOATBUILDING__QBProductServiceConfig__c> mapQBProductServiceCS = BOATBUILDING__QBProductServiceConfig__c.getAll();
        Set<id> setWOJob = new Set<id>();
        list< BOATBUILDING__Work_Order_Job__c > lstWOJob = [Select id, BOATBUILDING__Job_Name__c, BOATBUILDING__No_of_Labors__c, BOATBUILDING__Price_per_Labor__c, BOATBUILDING__Shipping_Charge__c, BOATBUILDING__Shop_Supplies_Total__c from BOATBUILDING__Work_Order_Job__c where BOATBUILDING__Work_Order_Warranty_Work_Order__c =: objwo.id];
        for(BOATBUILDING__Work_Order_Job__c WO: lstWOJob){
            setWOJob.add(WO.id);
        }
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstWOJobLineItem = [Select id, BOATBUILDING__Part_Name__c, BOATBUILDING__Price__c, BOATBUILDING__Quantity__c from BOATBUILDING__Work_Order_Job_Line_Item__c where BOATBUILDING__Related_to_Job__c IN :setWOJob];
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();//pradeep
          gen.writeStringField('DocNumber',objwo.name);
        gen.writeFieldName('Line');
        gen.writeStartArray();
        for(BOATBUILDING__Work_Order_Job__c WoJob : lstWOJob){
            
            //For Labour
            gen.writeStartObject();
            gen.writeNumberField('Amount',WoJob.BOATBUILDING__No_of_Labors__c*WoJob.BOATBUILDING__Price_per_Labor__c);
            gen.writeStringField('Description','Labor');
            gen.writeStringField('DetailType','SalesItemLineDetail');
            //gen.writeStringField('DocNumber',objwo.name);
            
            gen.writeFieldName('SalesItemLineDetail');
            gen.writeStartObject();
            gen.writeFieldName('ItemRef');
            gen.writeStartObject();
            gen.writeStringField('value',mapQBProductServiceCS.get('Labour').BOATBUILDING__QBID__c);
            gen.writeStringField('name','Services');
            gen.writeEndObject();
            gen.writeNumberField('UnitPrice', WoJob.BOATBUILDING__Price_per_Labor__c!=null ? WoJob.BOATBUILDING__Price_per_Labor__c : 0.00);
            gen.writeNumberField('Qty',WoJob.BOATBUILDING__No_of_Labors__c);
            /****Code updated on 17th July 2017****/
            gen.writeFieldName('TaxCodeRef');
            gen.writeStartObject();
            gen.writeStringField('value','TAX');
            gen.writeEndObject();
            gen.writeEndObject();
            /****Code updated on 17th July 2017****/
            
            gen.writeEndObject();
            
            //for Shop Supplier
            gen.writeStartObject();
            gen.writeNumberField('Amount',WoJob.BOATBUILDING__Shop_Supplies_Total__c!=null? WoJob.BOATBUILDING__Shop_Supplies_Total__c : 0.00);
            gen.writeStringField('Description','Shop Supplier');
            gen.writeStringField('DetailType','SalesItemLineDetail');
            gen.writeFieldName('SalesItemLineDetail');
            gen.writeStartObject();
            gen.writeFieldName('ItemRef');
            gen.writeStartObject();
            gen.writeStringField('value',mapQBProductServiceCS.get('Shop Supplier').BOATBUILDING__QBID__c);
            gen.writeStringField('name','Services');
            gen.writeEndObject();
            gen.writeNumberField('UnitPrice', WoJob.BOATBUILDING__Shop_Supplies_Total__c!=null ? WoJob.BOATBUILDING__Shop_Supplies_Total__c : 0.00);
            gen.writeNumberField('Qty',1);
            /****Code updated on 17th July 2017****/
            gen.writeFieldName('TaxCodeRef');
            gen.writeStartObject();
            gen.writeStringField('value','TAX');
            gen.writeEndObject();
            /****Code updated on 17th July 2017****/
            gen.writeEndObject();
            gen.writeEndObject();
            
            //for Shipping Charge
            gen.writeStartObject();
            gen.writeNumberField('Amount',WoJob.BOATBUILDING__Shipping_Charge__c!=null? WoJob.BOATBUILDING__Shipping_Charge__c : 0.00);
            gen.writeStringField('Description','Shipping Charge');
            gen.writeStringField('DetailType','SalesItemLineDetail');
            gen.writeFieldName('SalesItemLineDetail');
            gen.writeStartObject();
            gen.writeFieldName('ItemRef');
            gen.writeStartObject();
            gen.writeStringField('value',mapQBProductServiceCS.get('Shipping Charge').BOATBUILDING__QBID__c);
            gen.writeStringField('name','Services');
            gen.writeEndObject();
            gen.writeNumberField('UnitPrice', WoJob.BOATBUILDING__Shipping_Charge__c!=null ? WoJob.BOATBUILDING__Shipping_Charge__c : 0.00);
            gen.writeNumberField('Qty',1);
            gen.writeEndObject();
            gen.writeEndObject();
            
            //for Sales Tax
            /*Not used gen.writeStartObject();
gen.writeNumberField('Amount',objwo.BOATBUILDING__Sales_Tax__c!=null? objwo.BOATBUILDING__Sales_Tax__c: 0.00);
gen.writeStringField('Description','Sales Tax');
gen.writeStringField('DetailType','SalesItemLineDetail');
gen.writeFieldName('SalesItemLineDetail');
gen.writeStartObject();
gen.writeFieldName('ItemRef');
gen.writeStartObject();
gen.writeStringField('value',mapQBProductServiceCS.get('Shipping Charge').BOATBUILDING__QBID__c);
gen.writeStringField('name','Services');
gen.writeEndObject();
gen.writeNumberField('UnitPrice', objwo.BOATBUILDING__Sales_Tax__c!=null ? objwo.BOATBUILDING__Sales_Tax__c : 0.00);
gen.writeNumberField('Qty',1);
gen.writeEndObject();
gen.writeEndObject();*/
            
        } 
        //For parts
        for(BOATBUILDING__Work_Order_Job_Line_Item__c WOJLnItm : lstWOJobLineItem){
            gen.writeStartObject();
            gen.writeNumberField('Amount', WOJLnItm.BOATBUILDING__Price__c*WOJLnItm.BOATBUILDING__Quantity__c);
            gen.writeStringField('Description',WOJLnItm.BOATBUILDING__Part_Name__c == null?'': WOJLnItm.BOATBUILDING__Part_Name__c);
            gen.writeStringField('DetailType','SalesItemLineDetail');
            gen.writeFieldName('SalesItemLineDetail');
            gen.writeStartObject();
            gen.writeFieldName('ItemRef');
            gen.writeStartObject();
            gen.writeStringField('value',mapQBProductServiceCS.get('Parts').BOATBUILDING__QBID__c);
            gen.writeStringField('name','Services');
            gen.writeEndObject();
            gen.writeNumberField('UnitPrice', WOJLnItm.BOATBUILDING__Price__c!=null? WOJLnItm.BOATBUILDING__Price__c : 0.00);
            gen.writeNumberField('Qty',WOJLnItm.BOATBUILDING__Quantity__c!=null? WOJLnItm.BOATBUILDING__Quantity__c : 0);
            /****Code updated on 17th July 2017****/
            gen.writeFieldName('TaxCodeRef');
            gen.writeStartObject();
            gen.writeStringField('value','TAX');
            gen.writeEndObject();
            /****Code updated on 17th July 2017****/
            gen.writeEndObject();
            gen.writeEndObject();
            
        }
        /***Code Added*/
        gen.writeStartObject();
        gen.writeNumberField('Amount', objwo.BOATBUILDING__Total_Discount__c!=null? objwo.BOATBUILDING__Total_Discount__c: 0.00);
        gen.writeStringField('DetailType','DiscountLineDetail');
        gen.writeFieldName('DiscountLineDetail');
        gen.writeStartObject();
        gen.writeFieldName('DiscountAccountRef');
        gen.writeStartObject();
        gen.writeStringField('value', '1');
        gen.writeStringField('name','Discounts given');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        /***Code Added*/
        
        gen.writeEndArray();
        gen.writeFieldName('CustomerRef');
        gen.writeStartObject();
        gen.writeStringField('value',QBId);
        gen.writeEndObject();
        //Code added sales tax  
        gen.writeFieldName('TxnTaxDetail');
        gen.writeStartObject();
        gen.writeFieldName('TxnTaxCodeRef');
        gen.writeStartObject();
        gen.writeNumberField('value', 7);
        gen.writeEndObject();
        gen.writeNumberField('TotalTax', objwo.BOATBUILDING__Sales_Tax__c!=null? objwo.BOATBUILDING__Sales_Tax__c:0.00);
        gen.writeEndObject();
        //Code added
        gen.writeEndObject();
        String strjson= gen.getAsString(); 
        System.debug('==strjson==' +strjson);
        return strjson;
    }
    
    
   
}