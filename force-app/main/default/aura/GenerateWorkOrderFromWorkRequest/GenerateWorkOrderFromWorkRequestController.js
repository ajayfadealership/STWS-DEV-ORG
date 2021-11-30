({
	 doinit: function(component, event, helper) {
        var action = component.get("c.generateWorkOrder");
        action.setParams({"recordId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            if(response.getReturnValue().includes("Error")) {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            } else {
                var urlEvent = $A.get("e.force:navigateToURL");
                var urlStr = "/"+response.getReturnValue();
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