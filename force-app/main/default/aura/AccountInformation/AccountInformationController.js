({
    handleClick : function(component, event, helper) {
        
        var objAcc = component.get("v.objAccountAI");
        if(objAcc.Name != undefined && objAcc.Name != null && objAcc.Name != "") {
            var cmpEvent = $A.get("e.c:AccountParentToChild");
            
            cmpEvent.setParams({ 
                "objAccount": objAcc,
                "tab": "two"
            });
            cmpEvent.fire();
            
            var id_str = parseInt(2);
            var nextInd = id_str+1;
            var prevInd = id_str - 1;
            var nextLI = nextInd+"LI";
            var prevLI = prevInd+"LI";
            var currLI = id_str+"LI";
            var nextId = "tab-default-"+nextInd;
            var CurrId = "tab-default-"+id_str;
            var PrevId = "tab-default-"+prevInd;
            var currElement = document.getElementById(CurrId);
            var nextElement = document.getElementById(nextId);
            $A.util.toggleClass(currElement, "slds-show");
            $A.util.toggleClass(currElement, "slds-hide");
            $A.util.toggleClass(nextElement, "slds-show");
            $A.util.toggleClass(nextElement, "slds-hide");
            var currLIel = document.getElementById(currLI);
            var nextLIel = document.getElementById(nextLI);
            $A.util.removeClass(currLIel, "slds-is-current");
            $A.util.removeClass(currLIel, "slds-is-active");
            $A.util.addClass(currLIel, "slds-is-complete");
            $A.util.removeClass(nextLIel, "slds-is-incomplete");
            $A.util.addClass(nextLIel, "slds-is-active");
            $A.util.addClass(nextLIel, "slds-is-current"); 
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Enter Account Name.",
                "duration":"5000",
                "key": 'info_alt',
                "type": 'error',
                "mode": 'dismissible'
            });
            toastEvent.fire();
        }
        
        
        
        
    },
    previousClick : function(component, event, helper) {
        var id_str = parseInt(2);
        console.log(id_str); 
        var prevInd = id_str - 1;
        
        
        var prevLI = prevInd+"LI";
        var currLI = id_str+"LI";
        
        
        var CurrId = "tab-default-"+id_str;
        var PrevId = "tab-default-"+prevInd;
        
        var currElement = document.getElementById(CurrId);
        var prevElement = document.getElementById(PrevId);
        $A.util.toggleClass(prevElement, "slds-show");
        $A.util.toggleClass(prevElement, "slds-hide");
        $A.util.toggleClass(currElement, "slds-show");
        $A.util.toggleClass(currElement, "slds-hide");
        console.log('asdfadsfasdf');
        var currLIel = document.getElementById(currLI);
        var prevLIel = document.getElementById(prevLI);
        $A.util.removeClass(currLIel, "slds-is-current");
        $A.util.removeClass(currLIel, "slds-is-active");
        $A.util.addClass(currLIel, "slds-is-incomplete");
        $A.util.removeClass(prevLIel, "slds-is-complete");
        $A.util.addClass(prevLIel, "slds-is-active");
        $A.util.addClass(prevLIel, "slds-is-current"); 
        
    },
    showPopAddSearch: function(component, event, helper) {
        document.getElementById("srchAddBarAW").style.display = "block";
    },
    nonePopAddSearch: function(component, event, helper) {
        document.getElementById("srchAddBarAW").style.display = "none";
    },
    HandelAccountEvent11: function(component, event, helper) {
        console.log('Called');
        var objAcc = event.getParam("objAccount");
        var tab = event.getParam("tab");
        var objAccEx = component.get("v.objAccountAI");
        if(tab == "Map") {
            objAccEx.BillingStreet = objAcc.BillingStreet; 
            objAccEx.BillingCity = objAcc.BillingCity;
            objAccEx.BillingState = objAcc.BillingState;
            objAccEx.BillingPostalCode = objAcc.BillingPostalCode;
            document.getElementById("srchAddBarAW").style.display = "none";
            component.set("v.objAccountAI", objAccEx);
        }
    }
    
})