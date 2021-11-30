({
    doInit : function(component, event, helper) {
        var action = component.get("c.getPORecordTypeId");
        action.setCallback(this, function(response){
            console.log("Response: "+response.getReturnValue());
            component.set("v.invRecordTypeId", response.getReturnValue());
        }); 
        $A.enqueueAction(action);

        var actionPP = component.get("c.getProductLineItem");
        actionPP.setCallback(this, function(response){
            console.log("Response getProductLineItem: "+JSON.stringify(response.getReturnValue()));
            component.set("v.lineItems", response.getReturnValue());
        }); 
        $A.enqueueAction(actionPP);
        var actionDO = component.get("c.getDealerOptions");
        actionDO.setCallback(this, function(response){
            console.log("Response getDealerOptions: "+JSON.stringify(response.getReturnValue()));
            component.set("v.dealerOptions", response.getReturnValue());
        }); 
        $A.enqueueAction(actionDO);

    },
    createBoat : function(component, event, helper) {
        console.log('>>: '+component.find("SLP").get("v.value"));
        var slp = component.find("SLP").get("v.value")
        if(slp != undefined && slp != null && slp != '') {
            component.find("refUsedBoat").submit();  
            
        } else {
            var errorEvent = $A.get("e.force:showToast");
            errorEvent.setParams({
                "type" : "error", 
                "title": "Error!",
                "message": "Please enter Suggested List Price."
            });
            errorEvent.fire();
        }   
    },
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
        console.log('>>>>: '+component.get("v.lineItemsToInsert"));
        console.log('>>>>: '+JSON.stringify(component.get("v.lineItemsToInsert")));
        console.log('>>>>component.get("v.dealerOptionsToInsert"): '+JSON.stringify(component.get("v.dealerOptionsToInsert")));
        if(payload.id != undefined && payload.id != null) {
            var action = component.get("c.updateLineItems");
            action.setParams({ 
                "strInvId" : payload.id,
                "lstProductPrice" : component.get("v.lineItemsToInsert"),
                "lstDealerOption": component.get("v.dealerOptionsToInsert"),
                "allDOList": JSON.stringify(component.get("v.dealerOptions"))
            });
            action.setCallback(this, function(response){
                console.log("Response: "+response.getReturnValue());
                if(response.getReturnValue().includes('Error')) {
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({
                        "type" : "error", 
                        "title": "Error!",
                        "message": "Something went wrong. "+response.getReturnValue()
                    });
                    errorEvent.fire();
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var urlStr = "/"+payload.id;
                    urlEvent.setParams({
                        "url": urlStr
                    });
                    urlEvent.fire();
                }
            }); 
            $A.enqueueAction(action);
        }
    },
    addDOPOPup : function(component, event, helper) {
        component.set("v.newDO", true);
    }
})