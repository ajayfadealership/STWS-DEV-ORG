({
    partDistribution:function(component,event,helper){
        var objLI = component.get("v.objLI");
        if(objLI.received > 0) {
            component.set("v.partDistribution", true);
        } else {
            var errorEvent = $A.get("e.force:showToast");
            errorEvent.setParams({
                "type" : "error", 
                "title": "Error!",
                "message": "Please enter quantity in 'Received'."
            }); 
            errorEvent.fire();
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.partDistribution", false)
    },
    addPA : function(component, event, helper) {
        var selectedLoc = component.find("topLocations").get("v.value");
        var lstPA = component.get("v.lstPA") != undefined ? component.get("v.lstPA") : [];
        if(selectedLoc != undefined && selectedLoc != null && selectedLoc != '' ) {
            if(lstPA.length > 0 && lstPA[lstPA.length -1].BOATBUILDING__Quantity__c > 0) {
                var objPA = new Object();
                objPA.BOATBUILDING__Store_Location__c = selectedLoc;
                objPA.BOATBUILDING__Quantity__c = 0;
                lstPA.push(objPA);
                component.set("v.lstPA", lstPA); 
            } else if(lstPA.length > 0) {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": "Quantity should be greater than 0."
                }); 
                errorEvent.fire();
            } else { 
                var objPA = new Object();
                objPA.BOATBUILDING__Store_Location__c = selectedLoc;
                objPA.BOATBUILDING__Quantity__c = 0;
                lstPA.push(objPA);
                component.set("v.lstPA", lstPA);
            } 
        } else {
            var errorEvent = $A.get("e.force:showToast");
            errorEvent.setParams({
                "type" : "error",
                "title": "Error!",
                "message": "Please select location."
            });
            errorEvent.fire();
        }
    },
    handleRemoveLineItem : function(component, event, helper) {
        var index = event.target.dataset.index;
        console.log(index);
        var LineItems = component.get("v.lstPA");
        LineItems.splice(index, 1);
        component.set("v.lstPA", LineItems); 
    },
})