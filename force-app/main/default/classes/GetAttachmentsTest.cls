@isTest
global class GetAttachmentsTest {
    static testMethod void doGetCoverage() {
       RestRequest req = new RestRequest();
       
        
       BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
       objInventory.Year__c = 'years';
       objInventory.Walkthrough__c = 'WalkThrough';
       objInventory.Underwater_lights__c = 'Underwater';
       objInventory.Transom_remote__c = 'transome';
       objInventory.Transom__c = 'transom';
       objInventory.Trailer_wheels__c= 'Trailer';
       objInventory.Trailer_VIN__c = 'trailers';
       objInventory.Tower_speakers__c = 'Tower';
       objInventory.Surf_system__c = 'Surf';
       objInventory.Steering_wheel_controls__c = 'Steering';
       objInventory.Status__c = 'statuss';
       objInventory.Stage__c  = 'Transit';
       objInventory.Speed_Wakeplate_levers__c = 'Speed';
       objInventory.Boat_Length_in_feets__c = 'Boast';
       objInventory.Side__c = 'side';
       objInventory.Part_Number__c = '123456';
       
       insert objInventory;
        
       Attachment attach=new Attachment();      
       attach.Name='Side__c.jpg';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=objInventory.id;
       insert attach;
        
       req.params.put('attId', attach.Id);
       RestResponse res = new RestResponse();
    
       RestContext.request = req;
       RestContext.response = res;
       Test.startTest();
   
       String result = GetAttachments.doGet();
  
       Test.stopTest();
    }  
}