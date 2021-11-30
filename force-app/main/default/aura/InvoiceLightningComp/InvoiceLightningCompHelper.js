({
    getLineItemHelper: function(component, recId) {
        var action = component.get("c.getLineItems"); 
        action.setParams({
            "strPOId" : recId 
        });
        action.setCallback(this, function(response) {
            component.set("v.Spinner", false); 
            if(response.getState() == "SUCCESS") 
            {
                var array = response.getReturnValue();
                array.forEach(element => {
                    element.discountPer = parseFloat(element.discountPer).toFixed(2);
                    element.discount = parseFloat(element.discount).toFixed(2);
                    element.Total = parseFloat(element.Total).toFixed(2);
                });
                component.set("v.items", response.getReturnValue());
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
            if(typeof InvoiceTotal != "undefined" && InvoiceTotal != null && !isNaN(InvoiceTotal))
                component.set("v.invTotal", InvoiceTotal);
        }
    },
    calculateTotalWebInvoice : function(component) {
        var partTotal = component.get("v.invTotal");
        var shippingCharge = 0.00;
        if(typeof component.find("shippingCharge") != "undefined"){
            shippingCharge = component.find("shippingCharge").get("v.value");
            if(shippingCharge == null || shippingCharge == ''){
                shippingCharge = 0.00;
            }
        } else {
            shippingCharge = 0.00;
        }
        var salesTax = 0.00;
        if(typeof component.get("v.salesTaxAmountWeb") != "undefined"){
            salesTax = component.get("v.salesTaxAmountWeb");
            if(salesTax == null || salesTax == ''){
                salesTax = 0.00;
            }
        } else {
            salesTax = 0.00;
        }
        var invdiscount = component.get('v.discountOnInvoice')  == null ? 0 :  component.get('v.discountOnInvoice');
        var grandTotal = parseFloat(partTotal) + parseFloat(shippingCharge) + parseFloat(salesTax) - invdiscount;
        component.set("v.invoiceGrandTotal",grandTotal);
    },
    getAccountRecordTypeId : function(component) {
        var getRecordType = component.get("c.AccountRecordTypeId"); 
        getRecordType.setParams({
            
        });
        getRecordType.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS") 
            { 
                component.set("v.AccRecordTypeId",response.getReturnValue());
                
                
            }
        });
        $A.enqueueAction(getRecordType);
        
    }
    
    
})