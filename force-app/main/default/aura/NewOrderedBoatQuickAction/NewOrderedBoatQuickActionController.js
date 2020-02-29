({
    ClickMe : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        var qouteId = component.get("v.recordId");
        var action = component.get("c.NewOrderedBoatCheckbox");
        action.setParams({ 'strQtId' : qouteId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
              	alert(response.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                var urlStr = "/"+component.get("v.recordId");
                urlEvent.setParams({
                    "url": urlStr
                });
                urlEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }    
           
        });
        $A.enqueueAction(action);
        
    }
})