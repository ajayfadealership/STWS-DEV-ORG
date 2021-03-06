({

    doInit : function(component, event, helper) {   
        console.log('recordId: '+component.get("v.recordId"));
        var recId = component.get("v.recordId");
        if(recId != '' && recId != null && recId != undefined) {
          
            helper.getLineItemHelper(component, recId); 
            
        } 
        var action = component.get("c.InvRecordTypeId");
        action.setCallback(this, function(response){
            component.set("v.InvRecordTypeId", response.getReturnValue());
        }); 
        $A.enqueueAction(action);

        var getSalesTax = component.get("c.getSalesTaxCustomSetting");
        getSalesTax.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
              component.set("v.salesTaxConfig", response.getReturnValue());
              console.log('salestaxxxxxxxxxx',response.getReturnValue());
              helper.calculateInvoiceTotalHelper(component, event, helper);
            }
        }); 
        $A.enqueueAction(getSalesTax);

    },
    addParts : function(component, event, helper) {
        console.log('call');
        component.set("v.showTotal", true);
        var lstLineItem = component.get("v.items") != undefined ? component.get("v.items") : [];
        if(lstLineItem.length > 0 && lstLineItem[lstLineItem.length - 1].PartNumber != '' && lstLineItem[lstLineItem.length - 1].Quantity > 0) {
            console.log(JSON.stringify(lstLineItem));
            var POLI = new Object();
            POLI.PartId = '';
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.Quantity = 0; 
            POLI.Cost = 0.00; 
            POLI.partMSRP = 0.00; 
            POLI.discountPer = 0.00;
            POLI.TotalWithoutDisc = 0.00;
            POLI.discount = 0.00;;
            lstLineItem.push(POLI);
            component.set("v.items", lstLineItem);
        }else if(lstLineItem.length > 0) {
            var errorEvent = $A.get("e.force:showToast");
            errorEvent.setParams({
                "type" : "error", 
                "title": "Error!",
                "message": "Please select the part and quantity should be greater than 0."
            });
            errorEvent.fire();
        } else {
            console.log(JSON.stringify(lstLineItem));
            var POLI = new Object();
            POLI.PartId = '';
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.Quantity = 0; 
            POLI.discountPer = 0.00;
            POLI.discount = 0.00;
            POLI.Cost = 0.00;
            POLI.TotalWithoutDisc = 0.00;  
            lstLineItem.push(POLI);
            component.set("v.items", lstLineItem);
        }
        
        
    },
    handleRemoveLineItem : function(component, event, helper) {
        var index = event.target.dataset.index;
        console.log(index);
        var poLineItems = component.get("v.items");
        poLineItems.splice(index, 1);
        
        component.set("v.items", poLineItems); 
        var total = 0.00;
        if(poLineItems.length > 0) {
            for(var i = 0; i < poLineItems.length; i++) {
                total += parseFloat(poLineItems[i].Quantity * poLineItems[i].Cost);
            }
        }  
        component.set("v.lineItemPopTotal", total);
    },
    backToList: function(component, event, helper) {
		component.set("v.showform", false);
		component.set("v.showlist", true);
	},
    handleSuccess: function(component, event, helper) {
        var payload = event.getParams().response;
        if(payload.id != undefined && payload.id != null) {
            var poLineItems = component.get("v.items");
           
        console.log("%%%%%%%%% ",poLineItems);
        console.log("InvoiceId "+payload.id);
        var action = component.get("c.UpdateInvoicewithLineItems");
        console.log(" Check");
       
        action.setParams({ 
            "strInvId" : payload.id,
            "strLineItems" : JSON.stringify(poLineItems)
        });
        action.setCallback(this, function(response){ 
            console.log("Response:>>>>>%$ "+response.getReturnValue());
            if(response.getReturnValue() == 'SUCCESS') {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({ 
                    "type" : "success",
                    "title": "Success!",
                    "message": "Invoice Successfully Created."
                });
                errorEvent.fire(); 
                if(component.get("v.recordId") == null || component.get("v.recordId") == "" || component.get("v.recordId") == undefined) {
                    component.set("v.showform", false);
                    component.set("v.showlist", true); 
                } else {
                    helper.getLineItemHelper(component, component.get("v.recordId"));
                }

            }
            else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
        //component.set('v.showSpinner', false);
       // component.set("v.showform", false);
        //component.set("v.showlist", true);
       // window.location='lightning/r/BOATBUILDING__Invoice__c/' + payload.id + '/view';

       
       
    }
},
    calculateInvoiceTotal : function(component, event, helper) {
        helper.calculateInvoiceTotalHelper(component, helper, event);
    },
  
    sumbmitInv : function(component, event, helper) {  
        console.log('>>>: call Check ');
             var strLocation = component.find("storeLocId").get("v.value");
             var isError = false;
             var errorMessage = '';
             if(strLocation == null || strLocation == "")  {
                isError = true;
                errorMessage = 'Please select Store Location.';
            }
            var LineItems = component.get("v.items");
            console.log('>>>: LineItems ',LineItems);
            if(LineItems.length == 0) {
                isError = true;
                errorMessage = 'Please add some parts.';
            } else {
                if(LineItems.length > 0 && (LineItems[LineItems.length - 1].PartNumber == '' || LineItems[LineItems.length - 1].Quantity <= 0)) {
                    isError = true;
                    errorMessage = "Please select the part and quantity should be greater than 0.";
                } 
            }
            console.log("IsError",isError);
            if(!isError) { 
                component.find("InvoID").submit();
            } else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : 'error',
                    "title": "Error!",
                    "message": errorMessage
                });
                errorEvent.fire();
            }
               
               
        },
        calculateGrandTotal : function(component, event, helper){
            var salesTaxObject =  JSON.parse(component.get("v.salesTaxConfig"));
            console.log('salesTaxObject',salesTaxObject);
            var salesTax = 0.00;
            var salesTaxPercent = 0.00;
            if(salesTaxObject != null && typeof salesTaxObject != "undefined"){
                var state = component.find("billingState");
                if(typeof state != "undefined"){
                    var bState = state.get("v.value");
                    console.log('bstate',bState);
                    var salesTaxSetting = salesTaxObject[bState];
                    console.log('salesTaxSetting',salesTaxSetting);
                    if(typeof salesTaxSetting != "undefined"){
                        salesTaxPercent = salesTaxSetting.BOATBUILDING__Regular_Sales_Tax__c;
                        console.log('salesTaxPercent inside',salesTaxPercent);

                    }
                }
            }
            console.log('salesTaxPercent',salesTaxPercent);
            var partTotal = component.get("v.invTotal");
            var shippingCharge = 0.00;
            if(typeof component.find("shippingCharge") != "undefined"){
                shippingCharge = component.find("shippingCharge").get("v.value");
                if(shippingCharge == null){
                    shippingCharge = 0.00;
                }
            }
            var salesTax = (parseFloat(partTotal)/100)  * salesTaxPercent;
            console.log('shippingCharge',shippingCharge);
            component.set("v.salesTaxAmount",salesTax);
            
            
            var grandTotal = parseFloat(partTotal) + parseFloat(shippingCharge) + salesTax;
            
            component.set("v.invoiceGrandTotal",grandTotal);
        }
                
        
   
})