({
    doInit : function(component, event, helper) {
        var action = component.get("c.getrecordType");
        action.setCallback(this, function(response) {
            console.log('>>>>: ' + response.getReturnValue());
            component.set("v.recordTypeId", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    onRecordSuccess : function(component, event, helper) {
        console.log('Success');
        var payload = event.getParams().response;
        console.log(payload.id);
        component.set("v.showSpinner", true);
        var action = component.get("c.updateTechOnALlJobs");
        action.setParams({
            strTMId : payload.id
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var event = $A.get("e.force:showToast");
            event.setParams({
                "type" : "success",
                "title": "Success!",
                "message": "Work Order is scheduled."
            });
            event.fire();
            if(response.getReturnValue().includes("Error")) {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            } 
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },
    updateCustomerlookup : function(component, event, helper) { 
        var type = component.find("type").get("v.value");
        if(type == 'Pickup' || type == 'Drop') {
            component.set("v.isPD", true);
        } else {
            component.set("v.isPD", false);
        }
    }
})