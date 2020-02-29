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
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been saved successfully.",
            "type":"success"
        });
        toastEvent.fire();
        var payload = event.getParams().response;
        console.log(payload.id);
        var action = component.get("c.cpofPartReq");
        action.setParams({
            PRId : payload.id
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
        });
       $A.enqueueAction(action);
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