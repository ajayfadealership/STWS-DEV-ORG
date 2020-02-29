({
    getRecordTypeId: function(component, event, helper) {
        var action = component.get("c.getRecTypeId");
        action.setCallback(this, function(response) {
            component.set("v.attrRecordType", response.getReturnValue());
       
      });
        $A.enqueueAction(action);
    },
    save : function(component,event,helper) {
        component.find("recordEditForm").submit();
        component.set('v.showSpinner', true);
  
    },
   handleSuccess: function(component, event, helper) {
        
        var payload = event.getParams().response;
        console.log(payload.id);
        var action = component.get("c.cpofPartReq"); 
        action.setParams({ 
            PRId : payload.id
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set('v.showSpinner', false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"success",
                "message": "The record has been updated successfully."
            });
            toastEvent.fire();
        });
       $A.enqueueAction(action);
       var navLink = component.find("navService");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'BOATBUILDING__Order__c',
                recordId : payload.id
            },
        };
        navLink.navigate(pageRef, true);
    },
    handleLoad: function(component, event, helper) {
        component.set('v.showSpinner', false);
    },
    handleSubmit:  function(component, event, helper) {
        component.set('v.showSpinner', true);
    },
    
    backToList: function(component, event, helper) {
		component.set("v.showform", false);
		component.set("v.showlist", true);
    },
    uplaodFinished : function(component, event, helper){
        var childCmp = component.find("photoCmp")
        console.log('photoCMP4photoCMP4', childCmp);
        childCmp.refreshChild();
    }
})