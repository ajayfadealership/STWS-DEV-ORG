({
    doInit : function(component, event, helper) {
        
        var invId = component.get("v.recordId");
        var action = component.get("c.updateOnWebLightning");
        action.setParams({
            "invId" : invId
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            console.log(response.getReturnValue());
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                 
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        title: "Success!",
                        message: result,
                        type: "success"
                        
                    });
                    
                    toastEvent.fire();
                
               
            } 
            else{ 
                var toastEvent = $A.get("e.force:showToast");
                console.log("Error Message: ", response.getError()[0].message);
                toastEvent.setParams({
                    title: "Error!",
                    message: "Something went wrong. Please try again or contact your system administrator",
                    type: "error"
                    
                }); 
                toastEvent.fire();
            } 
        });
        
        $A.enqueueAction(action); 
    }
})