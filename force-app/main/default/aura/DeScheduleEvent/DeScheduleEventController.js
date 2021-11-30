({
    doInit: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var actionUserInfo = component.get("c.getUserInfo");
        actionUserInfo.setCallback(this, function (response) {
            console.log('actionUserInfo ', response.getReturnValue().UserRole.Name);
            component.set("v.UserRoleName", response.getReturnValue().UserRole.Name);
            var actionGetWOEvents = component.get("c.getWOEvents");
            actionGetWOEvents.setParams({ strWOId: component.get("v.recordId") });
            actionGetWOEvents.setCallback(this, function (response1) {
                component.set("v.showSpinner", false);
                console.log('actionGetWOEvents ', response1.getReturnValue());
                component.set("v.eventOptions", response1.getReturnValue()); 
                if(response1.getReturnValue().length == 1) {
                    component.set("v.eventValue", response1.getReturnValue()[0].value); 
                    component.set("v.showForm", true); 
                }
            });
            $A.enqueueAction(actionGetWOEvents);
        });
        $A.enqueueAction(actionUserInfo);
    },
    deselectEvent : function (component, event, helper) {
        console.log('Delete');
        component.find("scheduleChangeForm").submit();
    },
    handleChange: function (component, event, helper) {
        component.set("v.showForm", true); 
    },
    handleError: function (component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
        var errorEvent = $A.get("e.force:showToast");
        errorEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": JSON.stringify(errors)
        });
        errorEvent.fire();
    },
    handleSuccessChnage: function (component, event, helper) {
        var recId = component.get("v.eventValue");
        var action = component.get("c.deleteEvent");
        action.setParams({
            strTMId: recId
        });
        action.setCallback(this, function (response) {
            console.log(response.getReturnValue());
            var errorEvent = $A.get("e.force:showToast");
            errorEvent.setParams({
                "type": "success",
                "title": "Success!",
                "message": "Event is successfully rescheduled."
            });
            errorEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
        
    }
})