({
	doint : function(component, event, helper) {
       
                 var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":"/apex/BOATBUILDING__PrintWorkOrderQRSheet/?id="+component.get("v.recordId")
                });
                urlEvent.fire();
            
    }
})