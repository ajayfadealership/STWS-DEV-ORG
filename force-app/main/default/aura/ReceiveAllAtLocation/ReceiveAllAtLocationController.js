({
    ReceiveAllAtLocation :function(component,event,helper){
         component.set("v.ReceiveAllAtLocation ", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.ReceiveAllAtLocation ", false)
    },
    addPA : function(component, event, helper) {
        var objLI = component.get("v.objLI");
        var selectedLoc = component.find("topLocations").get("v.value");
        
       var action = component.get("c.partAvailabilityAtLocation");
        action.setParams({"selectedLocation" : selectedLoc});
        action.setParams({"lineItem" : objLI});
        action.setCallback(this, function(res) {
            console.log('>>>>>: '+JSON.stringify(res.getReturnValue()));
           
        });
        $A.enqueueAction(action);
 
    },
   
})