({
    doInit : function(component, event, helper) {
        var twoId = component.get("v.recordId");
        helper.getWOInfo(component, twoId);
    }
})