({
    doInit : function(component, event, helper) {
        console.log(component.get("v.recordId"));
        var recId = component.get("v.recordId");
        var action = component.get("c.getType");
        action.setParams({
            "strInvId" : recId
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            //strObjType
            debugger;
            component.set("v.strObjType", response.getReturnValue());
            debugger;
            if(response.getReturnValue() == 'INVOICE') {
                helper.fetchDetails(component, event, recId);
            } else if(response.getReturnValue() == 'WORKORDER'){
                helper.fetchDetailsWO(component, event, recId);
            }
        });
        $A.enqueueAction(action);
    },
    updatePaymentButtom : function(component, event, helper) {
        console.log('Check::: '+component.find("pType"));
        if(component.find("pType") != undefined) {
            var picVal = component.find("pType").get("v.value");
            console.log(picVal);
            var isBoolGate = false;
            if(picVal == "Credit_Card") {
                isBoolGate = true;
            } 
            component.set("v.isGateway", isBoolGate);
        }
    },
    proceedToGateWay : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var urlStr = component.get("v.strURL")+'?invId='+component.get("v.recordId")+'&amount='+component.get("v.amount");;
        urlEvent.setParams({
            "url": urlStr
        });
        urlEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    onRecordSuccess : function(component, event, helper) { 
        $A.get("e.force:closeQuickAction").fire();
    },
    onRecordSubmit : function(component, event, helper) {
        component.find('payForm').submit();  
    },
    onRecordSubmitWO : function(component, event, helper) {
        component.find('payFormWO').submit();  
    },
    proceedToGateWayWO : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var urlStr = component.get("v.strURL")+'?woId1='+component.get("v.recordId")+'&amount='+component.get("v.amount");
        urlEvent.setParams({
            "url": urlStr
        });
        urlEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    updatePaymentButtomWO : function(component, event, helper) {
        console.log('Check::: '+component.find("WOpType"));
        if(component.find("WOpType") != undefined) {
            var picVal = component.find("WOpType").get("v.value");
            console.log(picVal);
            var isBoolGate = false;
            if(picVal == "Credit Card") {
                isBoolGate = true;
            } 
            component.set("v.isGateway", isBoolGate);
        }
    }
})