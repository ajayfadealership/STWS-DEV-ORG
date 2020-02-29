({
    getStoreLocationAndCount : function(component) {
        var action = component.get("c.getSlocationDetails");
        action.setCallback(this, function(response) {
            console.log("Response locations", response.getReturnValue());
            var lst = response.getReturnValue();
            component.set("v.locationCount", parseInt(lst[0]));
            component.set("v.locations", lst[1]);
            
        }); 
        $A.enqueueAction(action);
    }
})