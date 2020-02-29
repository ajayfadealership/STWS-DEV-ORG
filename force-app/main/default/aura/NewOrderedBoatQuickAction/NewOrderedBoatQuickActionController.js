({
    ClickMe : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        var qouteId = component.get("v.recordId");
        var action = component.get("c.NewOrderedBoatCheckbox");
        action.setParams({ 'strQtId' : qouteId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
              	//alert(response.getReturnValue());
              	var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": response.getReturnValue()
                }); 
                errorEvent.fire();
                var urlEvent = $A.get("e.force:navigateToURL");
                var urlStr = "/"+component.get("v.recordId");
                urlEvent.setParams({
                    "url": urlStr
                });
                urlEvent.fire();
                $A.get("e.force:closeQuickAction").fire(); 
                
            }    
            else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
        
    }
})