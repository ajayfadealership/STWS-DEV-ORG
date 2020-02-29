({
   createRecord: function(component, event, helper) {
       component.set("v.fromBBNav2", 'true');
       var windowHash = window.location.hash;
      var createRecordEvent = $A.get("e.force:createRecord");
      createRecordEvent.setParams({
         "entityApiName": "Account",
          
        "panelOnDestroyCallback": function(event1) {
            //console.log('event',event1);
           	window.location.href = "/lightning/n/BOATBUILDING__Quote_Wizard?redirect=frombbwiz"; 
        }
      });
      createRecordEvent.fire();
   }
})