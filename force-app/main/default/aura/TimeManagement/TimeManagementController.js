({
    init : function(component, event, helper) {
        //var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        helper.changeButtonStatus(component, event, helper);

    }, 
    dayIn : function(component, event, helper){
        var action = component.get("c.updateDayIn");
        action.setParams({
            "dayIn" : component.get("v.objTimeM")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.objTimeM", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":'success',
                    "message": "Welcome! You are In for the day. Please do not forget to lunchout/Dayout."
                });
                toastEvent.fire();
                helper.changeButtonStatus(component, event, helper);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "mode":"sticky",
                    "message": "dang! There was an error. Please report this to FAD Support using Ticket System from your home page"
                });
                toastEvent.fire();
                console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    dayOut : function(component, event, helper){
        var action = component.get("c.updateDayOut");
        action.setParams({
            "dayIn" : component.get("v.objTimeM")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.objTimeM", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":'success',
                    "message": "Thanks! You are out for the day.Have a good evening!"
                });
                toastEvent.fire();
                helper.changeButtonStatus(component, event, helper);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "mode":"sticky",
                    "message": "dang! There was an error. Please report this to FAD Support using Ticket System from your home page"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    lunchIn : function(component, event, helper){
        var action = component.get("c.updateLunchIn");
        action.setParams({
            "dayIn" : component.get("v.objTimeM")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.objTimeM", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":'success',
                    "message": "Welcome back! We hope you had a great lunch. Please do not forget to Day out at the end of the day."
                });
                toastEvent.fire();
                helper.changeButtonStatus(component, event, helper);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "mode":"sticky",
                    "message": "dang! There was an error. Please report this to FAD Support using Ticket System from your home page"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    lunchOut : function(component, event, helper){
        var action = component.get("c.updateLunchOut");
        action.setParams({
            "dayIn" : component.get("v.objTimeM")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.objTimeM", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":'success',
                    "message": "Thanks! Enjoy your meal. Please do not forget to Lunch IN when you are back."
                });
                toastEvent.fire();
                helper.changeButtonStatus(component, event, helper);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "mode":"sticky",
                    "message": "dang! There was an error. Please report this to FAD Support using Ticket System from your home page"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})