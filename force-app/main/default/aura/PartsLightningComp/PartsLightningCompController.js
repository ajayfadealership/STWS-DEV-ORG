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
        component.set('v.showSpinner', false);
        component.set("v.showform", false);
        component.set("v.showlist", true);
            var payload = event.getParams().response;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"success",
                "message": "The record has been created successfully."
            });
            toastEvent.fire();
        

        var navLink = component.find("navService");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'BOATBUILDING__Part__c',
                recordId : payload.id
            },
        };
        navLink.navigate(pageRef, true);
       
    },
    handleError : function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "There was an error!"
            });
            toastEvent.fire();
         component.set('v.showSpinner', false);
            console.log(event.getParam('detail'));
            

            
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
	}
})