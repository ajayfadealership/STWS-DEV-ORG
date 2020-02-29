({
	generateDealerQuote : function(component, event, helper) {
		console.log(component.get("v.recordId"));
        var action = component.get("c.generateDealerQuoteApex");
        action.setParams({ 
            "strQuoteId" : component.get("v.recordId") 
        });

        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') { 
                //component.set("v.NoSalesmanWithoutCost", res.getReturnValue());
                window.open('/'+res.getReturnValue());
                window.open("/"+component.get("v.recordId"), "_self");
            } 
        });  
        
        $A.enqueueAction(action);
	}
})