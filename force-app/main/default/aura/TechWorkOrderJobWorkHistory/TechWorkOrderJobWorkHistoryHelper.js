({
    getTMRecords : function(component) {
        var action = component.get("c.getTMHistory");
        action.setParams({
            "jobId" : component.get("v.jobId")
        });
        action.setCallback(this, function(response) {
            console.log("Response TM History: "+JSON.stringify(response.getReturnValue()));
        });
        $A.enqueueAction(action);
    }
})