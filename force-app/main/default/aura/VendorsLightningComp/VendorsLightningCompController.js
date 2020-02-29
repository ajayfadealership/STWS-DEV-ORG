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