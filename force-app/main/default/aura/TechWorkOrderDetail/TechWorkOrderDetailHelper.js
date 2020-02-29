({
    getWOInfo : function(component, recId) {
        component.set("v.showSpinnerP", true);
        var action = component.get("c.getWorkOrderDetail");
        action.setParams({
            strRecId : recId
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinnerP", false);
            console.log('Response: ', response.getReturnValue());
            component.set("v.objTWO", response.getReturnValue()[0]);
            component.set("v.objTWOJobs", response.getReturnValue()[1]);
        });
        $A.enqueueAction(action);
    }
})