({
    fetchDetails : function(component, event, recId) {
        var action = component.get("c.getPaymentURLInfo");
        action.setParams({
            "strInvId" : recId
        }); 
        action.setCallback(this, function(response) {
            console.log('Response', response.getReturnValue()); 
            console.log(response);
            console.log(JSON.stringify(response.getReturnValue()[0]));
            console.log(JSON.stringify(response.getReturnValue()[1]));
            component.set("v.strURL", response.getReturnValue()[0]);
            component.set("v.objInvoice", response.getReturnValue()[1]);
        });
        $A.enqueueAction(action); 
    },
    fetchDetailsWO : function(component, event, recId) {
        var action = component.get("c.getPaymentURLInfoWO");
        action.setParams({
            "strInvId" : recId
        });  
        action.setCallback(this, function(response) {
            console.log('Response', response.getReturnValue()); 
            console.log(response);
            console.log(JSON.stringify(response.getReturnValue()[0]));
            console.log(JSON.stringify(response.getReturnValue()[1]));
            component.set("v.strURL", response.getReturnValue()[0]);
            component.set("v.objWO", response.getReturnValue()[1]);
        });
        $A.enqueueAction(action); 
    }
})