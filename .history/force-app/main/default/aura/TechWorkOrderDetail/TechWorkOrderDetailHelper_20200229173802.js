({
    getWOInfo : function(component, recId) {
        component.set("v.showSpinnerP", true);
        var action = component.get("c.getWorkOrderDetail");
        action.setParams({
            strRecId : recId
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinnerP", false);
            var actSec = [];
            var jobs = response.getReturnValue()[1];
            for(var i = 0; i < jobs.length; i++){
                actSec.push(jobs[i].Id);
            }
            actSec.push('WOJDetails');
            component.set("v.activeSectionName", actSec);
            console.log('Response: ', response.getReturnValue());
            component.set("v.objTWO", response.getReturnValue()[0]);
            component.set("v.objTWOJobs", response.getReturnValue()[1]);
            
        });
        $A.enqueueAction(action);
    }
})