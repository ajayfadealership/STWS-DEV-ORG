({
	doint : function(component, event, helper) {
        var action = component.get('c.getPDFName'); 
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
                 var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":"/apex/BOATBUILDING__"+response.getReturnValue()+"?id="+component.get("v.recordId")
                });
                
                urlEvent.fire();
               
            }
        });
        $A.enqueueAction(action);
    }
})