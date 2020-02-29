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
    },
    recordTypeSelected : function(component, event, helper){
        var action = component.get("c.getRecordType");
        console.log("recordTypeName", component.get("v.recordTypeName"));
        action.setParams({
            "recTypeName" : component.get("v.recordTypeName")
        });
        action.setCallback(this, function(response){

            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.recordTypeId", response.getReturnValue());
            }

        });
        $A.enqueueAction(action);
    },
    handleSuccess : function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type": "success"
        });
        toastEvent.fire();
        
        console.log(event.getParam("id"));
        var navLink = component.find("navService");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'BOATBUILDING__Order__c',
                recordId : event.getParam("id") 
            },
        };
        navLink.navigate(pageRef, true);



    }
})