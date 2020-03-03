({
    doInit : function(component, event, helper) {
       var RecId = component.get("v.recordId");
       console.log('>>>>>>',RecId);
       var action = component.get("c.refundInvoice");
       action.setParams({ 
        "strInvId" : RecId
        
    });
    action.setCallback(this, function(response){
        var state = response.getState();
        if(state == 'SUCCESS') {
        console.log('>>>>>', response.getReturnValue());
        $A.get("e.force:closeQuickAction").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Invoice Refunded",
            "type":"success"
        });
        toastEvent.fire();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "There was an error. Please try again.",
                "type":"error"
            });
        toastEvent.fire();
    }
    }); 
    $A.enqueueAction(action);

    }
})