global class BatchSendWoUpdateNotification implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Name,BOATBUILDING__Account__c,BOATBUILDING__Discount_on_Jobs__c,BOATBUILDING__Contact__c,BOATBUILDING__Description__c,BOATBUILDING__Discount__c,BOATBUILDING__Grand_Total__c,BOATBUILDING__isQBIDonContact__c, OwnerId ,BOATBUILDING__Product__c,BOATBUILDING__QBInvoiceID__c,BOATBUILDING__QBInvoiceStatus__c,BOATBUILDING__Sales_Tax_Percent__c,BOATBUILDING__Sales_Tax__c,BOATBUILDING__Status__c,BOATBUILDING__Total_Amount_Due__c,BOATBUILDING__Total_Discount__c,BOATBUILDING__Total_Parts__c,BOATBUILDING__Total_Payment_job__c,BOATBUILDING__Total_Payment_payment__c,BOATBUILDING__Total_Shipping_Charges__c, BOATBUILDING__Customer_Last_updated__c ,BOATBUILDING__Total_Shop_Supplies__c,BOATBUILDING__Total__c, BOATBUILDING__SendInvoiceToQB__c FROM BOATBUILDING__Work_Order__c where  BOATBUILDING__Status__c =\'Closed\' ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BOATBUILDING__Work_Order__c> scope) {
        BOATBUILDING__Update_Customer_Notification__c updateCusEmailSetting = BOATBUILDING__Update_Customer_Notification__c.getValues('STWS');
        List<Task>lstofTaskTOInsert = new List<Task>();
        for(BOATBUILDING__Work_Order__c objWo :scope ){
            Integer dateDiff = DateTime.now().day() - objWo.BOATBUILDING__Customer_Last_updated__c.day();
            System.debug('testdiffence'+dateDiff);
            if(dateDiff >= updateCusEmailSetting.BOATBUILDING__Frequency_of_Reminder__c){
                if(updateCusEmailSetting != null){
                    if(updateCusEmailSetting.BOATBUILDING__Email_Notification__c ||(!updateCusEmailSetting.BOATBUILDING__Email_Notification__c && !updateCusEmailSetting.BOATBUILDING__Task_Notification__c)){
                        // SEND EMAIL
                        
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new String[] {objWo.ownerid};
                            message.settargetObjectId(objWo.ownerid);
                        message.SaveAsActivity = false;
                        
                        message.setTemplateId(updateCusEmailSetting.BOATBUILDING__Email_Template_Id__c);
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                        } else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                        }
                    }
                    if(updateCusEmailSetting.BOATBUILDING__Task_Notification__c){
                        // create task
                        Task objTask = new Task();
                        objTask.ownerid = objWo.ownerid;
                        objTask.whatid = objWo.id;
                        lstofTaskTOInsert.add(objTask);
                    }
                }
            }
        }
        if(!lstofTaskTOInsert.isEmpty())
            Insert lstofTaskTOInsert;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}