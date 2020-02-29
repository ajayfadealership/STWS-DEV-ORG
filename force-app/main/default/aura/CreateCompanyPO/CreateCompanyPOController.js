({
   createRecord: function(component, event, helper) {
       
      var createRecordEvent = $A.get("e.force:CreateRecord");
       
      /* alert(component.get("v.recordIdOFRomVF"));
       createRecordEvent.setParams({
         "entityApiName": "BOATBUILDING__Order__c",
           "recordTypeId": "0126F000001MIbG"
      });
      createRecordEvent.fire(); 
       alert('hello'); */
       var callback = component.get("v.callback");
        if (callback){
            callback();
        }
   }
})