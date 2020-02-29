({
    doinit : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var urlStr = "/apex/BOATBUILDING__ServiceInspectionForm?woId="+component.get("v.recordId");
        urlEvent.setParams({
            "url": urlStr
        });
        urlEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})