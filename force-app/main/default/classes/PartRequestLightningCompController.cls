public  class PartRequestLightningCompController {
@AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Part Request').getRecordTypeId();        
        return recid;
    }  

    @AuraEnabled
    public static string cpofPartReq(String PRId){
        try {
            BOATBUILDING__Order__c objOrder = [SELECT Id, Name, BOATBUILDING__Assigned_to__c, CreatedDate, LastModifiedDate FROM BOATBUILDING__Order__c Where Id =: PRId];
            if(objOrder.BOATBUILDING__Assigned_to__c != null
                && objOrder.CreatedDate == objOrder.LastModifiedDate) {
                doChatterPost(objOrder.BOATBUILDING__Assigned_to__c, 'Part Request', objOrder.Id);
            }
            return 'SUCCESS';
        } 
        catch(Exception ex) {
    		System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
    		return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
    	}
    }
    public static void doChatterPost(String assignTo, String type, String recId) {
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
        //Mention user here
        mentionSegmentInput.id = assignTo;
        messageBodyInput.messageSegments.add(mentionSegmentInput);
        String strTC = '\n'+'Hi,\n A new '+type+' is assigned to you.\nPlease have a look.\nThanks\n\n';
        textSegmentInput.text = strTC;
        messageBodyInput.messageSegments.add(textSegmentInput);
        entityLinkSegmentInput.entityId = recId;
        messageBodyInput.messageSegments.add(entityLinkSegmentInput);
        ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
        linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+recId;
        linkInput.urlName = 'Click here to open in Service App';
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.link = linkInput;
        feedItemInput.capabilities = feedElementCapabilitiesInput;
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = recId;
        
        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
        batchInputs.add(batchInput);
        ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
        System.debug('objCA_BR::: '+objCA_BR);
    }
}