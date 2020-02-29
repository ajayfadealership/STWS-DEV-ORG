({
    init : function(component, event, helper) {
        //var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var today = new Date();
        component.set('v.today', today);
        var action = component.get("c.getTimeManagement");
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                console.log('>>>>',response.getReturnValue());
                component.set("v.objTimeM", response.getReturnValue());
                helper.changeButtonStatus(component, event, helper);
            }
        });
         $A.enqueueAction(action);

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
    dayOut : function(component, event, helper){
        
    },
    lunchIn : function(component, event, helper){
        
    },
    lunnchOut : function(component, event, helper){
        
    }
})