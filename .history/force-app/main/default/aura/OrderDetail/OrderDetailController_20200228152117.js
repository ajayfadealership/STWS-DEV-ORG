({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        //console.log('Recrod type Id: '+component.get("v.pageReference").state.recordTypeId);
        
        var action = component.get("c.getRecordTypeDetail");
        action.setParams({
            "strRecId" : recId
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            if(response.getReturnValue() == 'Purchase_Order') {
                component.set("v.showPO", true);
            } else if(response.getReturnValue() == 'Order') {
                component.set("v.showO", true);
            }
        });
        $A.enqueueAction(action); 
    }
})