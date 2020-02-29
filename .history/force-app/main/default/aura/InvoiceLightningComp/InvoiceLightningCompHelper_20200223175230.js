({
     getLineItemHelper: function(component, recId) {
        var action = component.get("c.getLineItems"); 
        action.setParams({
            "strPOId" : recId 
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.items", response.getReturnValue());
                console.log("SSSSSSSSSSSSSS"+response.getReturnValue());
              
               
            }
        });
        $A.enqueueAction(action);
    },
    calculateInvoiceTotalHelper : function(component, event, helper){
        var InvoiceTotal = 0.00;
        var shipingcharge = component.find("shippCharge") ;
        var LineItems =  component.get("v.items");
        if(LineItems.length > 0) {
            for(var i= 0 ; i <  LineItems.length; i++){
                if(typeof LineItems[i] != "undefined" && LineItems[i].Total != null && !isNaN(LineItems[i].Total))
                InvoiceTotal = parseFloat(InvoiceTotal) + parseFloat(LineItems[i].Total);
            
            }
            console.log('InvoiceTotalInvoiceTotal',InvoiceTotal);
            if(typeof InvoiceTotal != "undefined" && InvoiceTotal != null && !isNaN(InvoiceTotal))
            component.set("v.invTotal", InvoiceTotal);
            

        }


    }
	 
})