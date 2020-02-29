({
    handleClick : function(component, event, helper) {
        var objInv = component.get("v.objInvPD");
        var cmpEvent = $A.get("e.c:InventoryChildToParent");
        cmpEvent.setParams({ 
            "objInventory": objInv,
            "tab": "three"
        });
        cmpEvent.fire();
        
        var id_str = parseInt(3);
        var nextInd = id_str+1;
        var prevInd = id_str - 1;
        var nextLI = "in"+nextInd+"LI";
        var prevLI = "in"+prevInd+"LI";
        var currLI = "in"+id_str+"LI";
        var nextId = "intab-default-"+nextInd;
        var CurrId = "intab-default-"+id_str;
        var PrevId = "intab-default-"+prevInd;
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
        
        
        
    },
    previousClick : function(component, event, helper) {
        var id_str = parseInt(3);
        console.log(id_str); 
        var prevInd = id_str - 1;
        
        
        var prevLI = "in"+prevInd+"LI";
        var currLI = "in"+id_str+"LI";
        
        
        var CurrId = "intab-default-"+id_str;
        var PrevId = "intab-default-"+prevInd;
        
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