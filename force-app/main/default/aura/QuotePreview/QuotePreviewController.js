({
    HandelQE : function(component, event, helper) {
        console.log('Called')
        var objQT = event.getParam("ObjQuote");
        console.log(objQT.Id);
        component.set("v.ObjQuoteC", objQT);
        console.log(component.get("v.ObjQuoteC"));
    },
    doInit: function(component, event, helper) {
        var action = component.get("c.getState");
        action.setCallback(this, function(res) {
            if(res.getState() == "SUCCESS") {
                component.set("v.StateSelect", res.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    updateState: function(component, event, helper) {
        var qtId = component.get("v.ObjQuoteC").Id;
        var stateC = document.getElementById("stateQuoteSelect").value;
        console.log('called');
        var action = component.get("c.updateStateApex");
        action.setParams({
            "quoteId": qtId,
            "state": stateC
        });
        action.setCallback(this, function(res) {
            if(res.getState() == "SUCCESS") {
                console.log(res.getReturnValue());
                component.set("v.ObjQuoteC", res.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    navigateToRecord: function(cmp, evt, hlrp) {
        var qtId = cmp.get("v.ObjQuoteC").Id;
        var urlEvent = $A.get("e.force:navigateToURL");
        window.onbeforeunload = null;
        $A.get('e.force:refreshView').fire();
        urlEvent.setParams({
            "url": '/'+qtId
        });
        urlEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})