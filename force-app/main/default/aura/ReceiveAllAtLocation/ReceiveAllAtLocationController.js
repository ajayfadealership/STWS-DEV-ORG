({
    ReceiveAllAtLocation :function(component,event,helper){
        component.set("v.ReceiveAllAtLocation ", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.ReceiveAllAtLocation ", false)
    },
    addPA : function(component, event, helper) {
        var lstLI = component.get("v.lstLI");
        console.log('>>>>>:list in JS '+JSON.stringify(lstLI));
        var selectedLoc = component.find("topLocations").get("v.value");
        console.log('>>>>>:location in JS '+selectedLoc);
        var orderId = component.get("v.recordId");
        var action = component.get("c.partAvailabilityAtLocation");
        action.setParams({
            "selectedLocation" : selectedLoc,
            "lineItem" : lstLI,
            "strOrderId" : orderId
        });
        action.setCallback(this, function(res) {
            console.log('>>>>>: '+JSON.stringify(res.getReturnValue()));
            
        });
        console.log('>>>parameter values '+component.get("v.recordId"));
        alert('Successfully Recieved');
        component.set("v.ReceiveAllAtLocation ", false)
        $A.enqueueAction(action);
        
    },
    
})