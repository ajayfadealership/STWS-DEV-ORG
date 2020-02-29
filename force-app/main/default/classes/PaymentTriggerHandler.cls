public class PaymentTriggerHandler{
    
    public Static string QBAccountID;
    //public Static String accID;
    
    public Static void onBeforeInsert(List<BOATBUILDING__Payment__c> lstPayment){
        //write code here for onBeforeInsert
        // updateAccountOnInvoice(lstPayment);
    }
    public Static void onAfterInsert(List<BOATBUILDING__Payment__c> lstPayment){
        
    }
    public Static void onAfterUpdate(List<BOATBUILDING__Payment__c> lstPayment , map<id,BOATBUILDING__Payment__c> oldMapPayment){
        System.debug('====afterUpdate===');
        createQBPayment(lstPayment, oldMapPayment);
        
    }
    
    public Static void createQBPayment(list<BOATBUILDING__Payment__c> lstPay, map<id,BOATBUILDING__Payment__c> oldMapPay){
        String payload;
        System.debug('===lstPay===' +lstPay[0].BOATBUILDING__Related_to_Invoice__r.BOATBUILDING__Account_Name__c);
        Set<Id> invID = new Set<Id>();
        Set<Id> accID = new Set<Id>();
        Map<Id,Id> mapInvToAccount = new Map<Id,Id>();
        
        for(BOATBUILDING__Payment__c pay : lstpay){
            invID.add(pay.BOATBUILDING__Related_to_Invoice__c);
        }
        
        System.debug('===invID===' +invID);
        
        for(BOATBUILDING__Invoice__c inv : [Select id,BOATBUILDING__Account_Name__c from BOATBUILDING__Invoice__c where Id IN: invID]){
            mapInvToAccount.put(inv.id, inv.BOATBUILDING__Account_Name__c);
            accID.add(inv.BOATBUILDING__Account_Name__c);
        }
        System.debug('==mapInvToAccount=='+mapInvToAccount);
        Map<id,Account> mapAcc = new Map<id,Account>([Select id,QBCustomerID__c from Account where id IN: accID]);
        System.debug('===mapAcc===='+mapAcc);
        
        for(BOATBUILDING__Payment__c pay: lstpay){
            
            //System.debug('==inv.Account_Name__r.QBCustomerID__c===' +mapAcc.get(inv.Account_Name__c).QBCustomerID__c);
            if(pay.BOATBUILDING__Send_Payment_to_QB__c && !oldMapPay.get(pay.id).BOATBUILDING__Send_Payment_to_QB__c){
                System.debug('Enter if send to QB' +mapAcc.get(mapInvToAccount.get(pay.BOATBUILDING__Related_to_Invoice__c)).QBCustomerID__c); 
                payload = generatePaymentJson(pay, mapAcc.get(mapInvToAccount.get(pay.BOATBUILDING__Related_to_Invoice__c)).QBCustomerID__c);
                NewQBConnectTest.CreateQBPayment(payload, pay.id);
            }
        }
        System.debug('====payload===='+payload);
        
    }
    
    
    //This Method is used to create a JSON for Invoice
    public Static String generatePaymentJson(BOATBUILDING__Payment__c pay, String QBId){
        System.debug('==pay.BOATBUILDING__QB_Invoice_ID__c ='+ pay.BOATBUILDING__QB_Invoice_ID__c);
        Map<String, BOATBUILDING__QBProductServiceConfig__c> mapQBProductServiceCS = BOATBUILDING__QBProductServiceConfig__c.getAll();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('CustomerRef');
        gen.writeStartObject();
        gen.writeStringField('value', QBId);
        gen.writeStringField('name','Boat Sales Tax');
        gen.writeEndObject();
        gen.writeNumberField('TotalAmt', pay.BOATBUILDING__Amount__c!=null? pay.BOATBUILDING__Amount__c: 0.00);
        gen.writeFieldName('Line');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeNumberField('Amount',pay.BOATBUILDING__Amount__c!=null? pay.BOATBUILDING__Amount__c: 0.00);
        gen.writeFieldName('LinkedTxn');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('TxnId',pay.BOATBUILDING__QB_Invoice_ID__c!=null? pay.BOATBUILDING__QB_Invoice_ID__c : '');
        gen.writeStringField('TxnType','Invoice');
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject(); 
        gen.writeEndArray(); 
        gen.writeEndObject();
        String strjson= gen.getAsString(); 
        System.debug('==strjsonFor payment==' +strjson);
        return strjson;
    }
    
}