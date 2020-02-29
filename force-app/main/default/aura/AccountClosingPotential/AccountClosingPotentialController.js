({
    handleClick : function(component, event, helper) {
        var objAcc = component.get("v.objAccountCP");
        var cmpEvent = $A.get("e.c:AccountParentToChild");
        cmpEvent.setParams({ 
            "objAccount": objAcc,
            "tab": "five"
        });
        cmpEvent.fire();
    },
    previousClick : function(component, event, helper) {
        var id_str = parseInt(5);
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
        
    }
})