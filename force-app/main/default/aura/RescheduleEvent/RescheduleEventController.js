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
        var errorEvent = $A.get("e.force:showToast");
        errorEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Event is successfully rescheduled."
        });
        errorEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
        
    },
    saveEvent : function (component, event, helper) {
        console.log('saveEvent');
        component.find("scheduleChangeForm").submit();
    },
    checkValues : function (component, event, helper) {
        let startDate = component.find("startDate").get("v.value");
        console.log('startDate:', startDate.split('T')[0]);
        component.set("v.startDate", startDate.split('T')[0]);
        let endDate = component.find("endDate").get("v.value");
        console.log('endDate:', endDate.split('T')[0]);
        component.set("v.endDate", endDate.split('T')[0]);
    }
})