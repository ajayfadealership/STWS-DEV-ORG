public class WorkOrderPaymentHandler {

   public Static void onAfterUpdate(List< BOATBUILDING__Work_Order_Payment__c > lstServPayment , map<id, BOATBUILDING__Work_Order_Payment__c > oldMapServPayment){
       System.debug('====afterUpdate===');
       createQBServicePayment(lstServPayment, oldMapServPayment);
    }
    
    public Static void createQBServicePayment(list<BOATBUILDING__Work_Order_Payment__c> lstPay, map<id, BOATBUILDING__Work_Order_Payment__c> oldMapPay){
      String payload;
      Set<Id> WoID = new Set<Id>();
      Set<Id> accID = new Set<Id>();
      Map<Id,Id> mapWOToAccount = new Map<Id,Id>();
      
      for(BOATBUILDING__Work_Order_Payment__c pay : lstpay){
          WoID.add(pay.BOATBUILDING__Related_to_Warranty_Work_Work_Order__c);
      }
      
      System.debug('===invID===' +WoID);
      
      for(BOATBUILDING__Work_Order__c WO : [Select id, BOATBUILDING__Account__c from BOATBUILDING__Work_Order__c where Id IN: WoID]){
          mapWOToAccount.put(WO.id, WO.BOATBUILDING__Account__c);
          accID.add(WO.BOATBUILDING__Account__c);
      }
      System.debug('==mapWOToAccount=='+mapWOToAccount);
      Map<id,Account> mapAcc = new Map<id,Account>([Select id,QBCustomerID__c from Account where id IN: accID]);
      System.debug('===mapAcc===='+mapAcc);
      
      for(BOATBUILDING__Work_Order_Payment__c pay: lstpay){
           
         //System.debug('==inv.Account_Name__r.QBCustomerID__c===' +mapAcc.get(inv.Account_Name__c).QBCustomerID__c);
         if(pay.BOATBUILDING__Send_Payment_to_QB__c && !oldMapPay.get(pay.id).BOATBUILDING__Send_Payment_to_QB__c){
             System.debug('Enter if send to QB' +mapAcc.get(mapWOToAccount.get(pay.BOATBUILDING__Related_to_Warranty_Work_Work_Order__c)).QBCustomerID__c); 
             payload = generateServicePaymentJson(pay, mapAcc.get(mapWOToAccount.get(pay.BOATBUILDING__Related_to_Warranty_Work_Work_Order__c)).QBCustomerID__c);
             NewQBConnectTest.CreateQBWorkOrderPayment(payload, pay.id);
        }
       }
        System.debug('====payload===='+payload);
        
    }
    
     //This Method is used to create a JSON for Invoice
  public Static String generateServicePaymentJson(BOATBUILDING__Work_Order_Payment__c pay, String QBId){
        System.debug('==pay.BOATBUILDING__QB_Invoice_ID__c ='+ pay.BOATBUILDING__QB_WorkOrder_ID__c);
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
                    gen.writeStringField('TxnId',pay.BOATBUILDING__QB_WorkOrder_ID__c!=null? pay.BOATBUILDING__QB_WorkOrder_ID__c : '');
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