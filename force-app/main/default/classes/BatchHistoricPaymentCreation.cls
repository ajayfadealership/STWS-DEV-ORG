global class BatchHistoricPaymentCreation implements Database.Batchable<sObject>{
    global Iterable<sObject> start(Database.BatchableContext BC) {
        
        List<sObject> listSObjectToReturn = new List<sObject>();
        List<BOATBUILDING__Work_Order_Payment__c> listWOP = [SELECT Id, BOATBUILDING__Amount__c,BOATBUILDING__Check_Number__c,
                                                             BOATBUILDING__Claim_Approval_Date__c,BOATBUILDING__Claim_Date__c,
                                                             BOATBUILDING__Claim_Labor_Approved_Amount__c,
                                                             BOATBUILDING__Claim_Labor_Paid_Amount__c,
                                                             BOATBUILDING__Claim_Paid_Date__c,BOATBUILDING__Claim_Status__c,
                                                             BOATBUILDING__Credit_Card_Type__c,BOATBUILDING__Credit_Note__c,
                                                             BOATBUILDING__MCSTransactionID__c,BOATBUILDING__Store_Location__c,
                                                             BOATBUILDING__Misc_Charge_Paid__c,BOATBUILDING__Work_Order_Job__c,
                                                             BOATBUILDING__Parts_Paid_Amount__c,BOATBUILDING__Payment_Type__c,
                                                             BOATBUILDING__ProcessorApprovalCode__c,
                                                             BOATBUILDING__ProcessorTransactionID__c,
                                                             BOATBUILDING__QB_WorkOrder_ID__c,
                                                             BOATBUILDING__QuickBook_WO_Payment_ID__c,
                                                             BOATBUILDING__Related_to_Warranty_Work_Work_Order__c,
                                                             BOATBUILDING__ResultCode__c,BOATBUILDING__ResultDetail__c,
                                                             BOATBUILDING__Return_Parts_Amount__c,
                                                             BOATBUILDING__Send_Payment_to_QB__c,
                                                             BOATBUILDING__WO_Closed_Date_Time__c,CreatedById,CreatedDate,
                                                             LastModifiedById,LastModifiedDate,Name
                                                             FROM BOATBUILDING__Work_Order_Payment__c
                                                             WHERE CreatedDate < 2020-04-16T00:00:00.000+0000];
        
        List<BOATBUILDING__Payment__c> listInvoiceP = [SELECT BOATBUILDING__Amount__c,BOATBUILDING__Check_Number__c,
                                                       BOATBUILDING__Credit_Card_Type__c,BOATBUILDING__Credit_Note__c,
                                                       BOATBUILDING__MCSTransactionID__c,BOATBUILDING__Payment_Created_Date__c,
                                                       BOATBUILDING__Payment_Type__c,BOATBUILDING__ProcessorApprovalCode__c,
                                                       BOATBUILDING__ProcessorTransactionID__c,BOATBUILDING__QB_Invoice_ID__c,
                                                       BOATBUILDING__QuickBook_Payment_ID__c,BOATBUILDING__Received_Cash__c,
                                                       BOATBUILDING__Related_to_Invoice__c,BOATBUILDING__ResultCode__c,
                                                       BOATBUILDING__ResultDetail__c,BOATBUILDING__Return_Change__c,
                                                       BOATBUILDING__Send_Payment_to_QB__c,BOATBUILDING__Store_Location__c,
                                                       CreatedById,CreatedDate,Id,LastModifiedById,LastModifiedDate,Name 
                                                       FROM BOATBUILDING__Payment__c
                                                       WHERE CreatedDate < 2020-04-16T00:00:00.000+0000];
        
        List<BOATBUILDING__All_Payment__c> listQuoteP = [SELECT Id, BOATBUILDING__Amount__c,BOATBUILDING__Check_Number__c,
                                                         BOATBUILDING__Credit_Card_Type__c,BOATBUILDING__MCSTransactionID__c,
                                                         BOATBUILDING__Payment_Type__c,BOATBUILDING__ProcessorApprovalCode__c,
                                                         BOATBUILDING__ProcessorTransactionID__c,BOATBUILDING__Quote__c,
                                                         BOATBUILDING__ResultCode__c,BOATBUILDING__ResultDetail__c,
                                                         BOATBUILDING__Store_Location__c,CreatedById,CreatedDate,
                                                         LastModifiedById,LastModifiedDate,
                                                         Name,OwnerId,RecordTypeId
                                                         FROM BOATBUILDING__All_Payment__c
                                                         WHERE CreatedDate < 2020-04-16T00:00:00.000+0000];
        listSObjectToReturn.addAll(listWOP);
        listSObjectToReturn.addAll(listInvoiceP);
        listSObjectToReturn.addAll(listQuoteP);
        return listSObjectToReturn;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        List<BOATBUILDING__Payments__c> listPaymentToCreate = new List<BOATBUILDING__Payments__c>();
        String strQuoteRecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
        String strStInvoicePaymntRecId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Standard Invoice').getRecordTypeId();
        String strWOPaymntRecId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
        String strWWOPaymntRecId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
        String strSBInvoicePaymntRecId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Sold Boat Invoice').getRecordTypeId();
        
        for(sObject obj: scope){
            BOATBUILDING__Payments__c objPay = new BOATBUILDING__Payments__c();
            if(String.valueOf(obj.getSObjectType()) == 'BOATBUILDING__Work_Order_Payment__c'){
                
            } else if(String.valueOf(obj.getSObjectType()) == 'BOATBUILDING__Payment__c'){
                
            } else if(String.valueOf(obj.getSObjectType()) == 'BOATBUILDING__All_Payment__c'){
                
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}