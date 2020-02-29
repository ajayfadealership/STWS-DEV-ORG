({
	handleClick : function(component, event, helper) {
        
        var objInv = component.get("v.objInvPP");
        var cmpEvent = $A.get("e.c:InventoryChildToParent");
        cmpEvent.setParams({ 
            "objInventory": objInv,
            "tab": "four"
        }); 
        cmpEvent.fire();
        
        var id_str = parseInt(4);
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
        var id_str = parseInt(4);
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
        
    },
    HandelMSRPEvent : function(component, event, helper) {
        console.log('Called');
    	var objInvEx = component.get("v.objInvPP");
        var msrp = event.getParam("msrp");
        console.log(msrp);
        objInvEx.BOATBUILDING__Total_MSRP_Price__c = parseFloat(msrp).toFixed(2);
        component.set("v.objInvPP", objInvEx);
    },
    HandelDealerPriceEvent: function(component, event, helper) {
        var dp = event.getParam("msrp");
        document.getElementById("hddnDlrPrc").value = dp;
        console.log('Dlr Prc: ' + dp);
    },
    calMinSP : function(component, event, helper) {
    	var objInvEx = component.get("v.objInvPP");
        var dlrCost = document.getElementById("hddnDlrPrc").value;
        var dc = 0.00
        if(dlrCost != null && dlrCost != undefined && !isNaN(parseFloat(dlrCost))) {
            dc = parseFloat(dlrCost);
        }
        if(objInvEx.BOATBUILDING__Costline__c != undefined ) {
            
            var costLine = (100 - objInvEx.BOATBUILDING__Costline__c)/100;
            
            objInvEx.BOATBUILDING__Minimum_Sell_Price__c = parseFloat(dc / costLine).toFixed(2);
            console.log(objInvEx.BOATBUILDING__Minimum_Sell_Price__c);
            
            objInvEx.BOATBUILDING__Costline_Dollar__c = parseFloat(objInvEx.BOATBUILDING__Minimum_Sell_Price__c - dc).toFixed(2);
            console.log(objInvEx.BOATBUILDING__Costline_Dollar__c);
            component.set("v.objInvPP", objInvEx); 
        }
        
    },
    calMinSPFE : function(component, event, helper) {
    	var objInvEx = component.get("v.objInvPP");
        var dlrCost = document.getElementById("hddnDlrPrc").value;
        
        var cstlne = event.getParam("costlinePoint"); 
        objInvEx.BOATBUILDING__Costline__c = cstlne;
        
        var dc = 0.00
        if(dlrCost != null && dlrCost != undefined && !isNaN(parseFloat(dlrCost))) {
            dc = parseFloat(dlrCost);
        }
        if(cstlne != undefined ) {
            
            var costLine = (100 - cstlne)/100;
            
            objInvEx.BOATBUILDING__Minimum_Sell_Price__c = parseFloat(dc / costLine).toFixed(2);
            console.log(objInvEx.BOATBUILDING__Minimum_Sell_Price__c);
            
            objInvEx.BOATBUILDING__Costline_Dollar__c = parseFloat(objInvEx.BOATBUILDING__Minimum_Sell_Price__c - dc).toFixed(2);
            console.log(objInvEx.BOATBUILDING__Costline_Dollar__c);
            component.set("v.objInvPP", objInvEx); 
        }
        
    },
    calMinSPWD : function(component, event, helper) {
    	var objInvEx = component.get("v.objInvPP");
        var dlrCost = document.getElementById("hddnDlrPrc").value;
        var dc = 0.00
        if(dlrCost != null && dlrCost != undefined && !isNaN(parseFloat(dlrCost))) { 
            dc = parseFloat(dlrCost);
        }
        if(objInvEx.BOATBUILDING__Costline_Dollar__c != undefined ) {

            objInvEx.BOATBUILDING__Minimum_Sell_Price__c = parseFloat(dc + objInvEx.BOATBUILDING__Costline_Dollar__c).toFixed(2);
            console.log("objInvEx.BOATBUILDING__Minimum_Sell_Price__c: "+objInvEx.BOATBUILDING__Minimum_Sell_Price__c)
            var costLine =  0.00;
            
            //objInvEx.BOATBUILDING__Minimum_Sell_Price__c = dc / costLine;
            console.log('>>objInvEx.BOATBUILDING__Minimum_Sell_Price__c: '+objInvEx.BOATBUILDING__Minimum_Sell_Price__c);
            costLine = dc/objInvEx.BOATBUILDING__Minimum_Sell_Price__c;
            console.log('>>costLine: '+costLine);
            objInvEx.BOATBUILDING__Costline__c = parseFloat(100 - (costLine *100)).toFixed(2);
            
            component.set("v.objInvPP", objInvEx); 
        }
        
    }
})