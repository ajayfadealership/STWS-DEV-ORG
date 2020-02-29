({
    changeToggle : function(component, event, helper) {
        var isChecked = component.find('inputToggle').get('v.checked');
        if(isChecked) {
            document.getElementById("newCustomerDiv").style.display ="block";
            document.getElementById("existingCustomerDiv").style.display ="none";
        }
        else {
            document.getElementById("newCustomerDiv").style.display ="none";
            document.getElementById("existingCustomerDiv").style.display ="block";
        }
        
    },
    handleClick : function(component, event, helper) {
        
        var objAcc = component.get("v.selectedLookUpRecord");
        if(objAcc != null && objAcc != undefined && objAcc.Id != null && objAcc.Id != undefined) {
            var urlEvent = $A.get("e.force:navigateToURL");
            window.onbeforeunload = null;
            urlEvent.setParams({
                "url": '/'+objAcc.Id
            });
            urlEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
        } else {
            helper.callNext(component, event);
        }
    },
    createRecord: function(component, event, helper) {
        helper.callNext(component, event);
    }
})