({
	doinit : function (component, event, helper) {             
        var action = component.get("c.getCustomerInq");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            console.log(response.getReturnValue());
            component.set("v.options", response.getReturnValue());
            component.set("v.default", response.getReturnValue()[0].value);
        }); 
        $A.enqueueAction(action);
    },
    handleChange : function (component, event, helper) {   
        var selectedOptionValue = event.getParam("value");
        console.log("Option selected with value: '" + selectedOptionValue + "'");
        component.set("v.default", selectedOptionValue);
    },
    handleDownload : function (component, event, helper) {   
        var selectedOptionValue = component.get("v.default");
        console.log("Option selected with value: '" + selectedOptionValue + "'");
        var action = component.get("c.XMLgen");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "custRecordId" : selectedOptionValue 
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success: ',response.getReturnValue());
                window.open(response.getReturnValue());
            }
            else if (state === "ERROR") {
                console.log('Error');
                let errors = response.getError();
                let toastParams = {
                    title: "Error",
                    message: "Unknown error", // Default error message
                    type: "error"
                };
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    toastParams.message = errors[0].message;
                }
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
            }
            else {
                 console.log('state: ',state);
            }
        }); 
        $A.enqueueAction(action);
    }
})