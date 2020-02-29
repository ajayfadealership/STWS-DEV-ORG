({
    loadDataTable : function(component, event, helper) {
        var action = component.get("c.getTodaysWO");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS" && response.getReturnValue().length > 0) {
                console.log('Response: '+JSON.stringify(response.getReturnValue()));
                var rtnValue = response.getReturnValue();
                rtnValue.forEach(objVal => {
                    objVal.linkLabel =  objVal.WOName;
                    objVal.WOName = '/'+ objVal.WOId;
                    console.log(objVal);
                });
                component.set("v.WOList", rtnValue);
            } 
            else {
                component.set("v.WOList", []);
            } 
        });
        $A.enqueueAction(action);
    },
    getCurrentUserHlpr : function(component, event, helper) {
        var action = component.get("c.getCurrentUser");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") { 
                console.log('Response Current User: ',response.getReturnValue());
                component.set("v.objUserP", response.getReturnValue());
                component.set("v.showPill", true); 
            }  
            else {
                component.set("v.WOList", []);
            } 
        });
        $A.enqueueAction(action);
    }
})