({
    doInit : function(component, event, helper) {
        console.log('objRecId: '+component.get("v.objRecId"));
        
        component.set("v.manuRecId", manuId); 
        var action = component.get("c.getLineItems");
        action.setParams({
            "strPOId" : component.get("v.objRecId")
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.lineItems", response.getReturnValue());
                var total = 0.00;
                if(response.getReturnValue().length > 0) {
                    for(var i = 0; i < response.getReturnValue().length; i++) {
                        total += parseFloat(response.getReturnValue()[i].Quantity * response.getReturnValue()[i].Cost);
                    }
                } 
                component.set("v.lineItemPopTotal", total);
            }
        });
        $A.enqueueAction(action);
    },
    handleLoad : function(component, event, helper) {

    },
    handleSubmit : function(component, event, helper) {

    },
    handleSuccess : function(component, event, helper) {

    },
    handleError : function(component, event, helper) {

    },
    calculateTotal : function(component, event, helper) { 
        console.log('Test');
        var poLineItems = component.get("v.lineItems");
        var total = 0.00;
        if(poLineItems.length > 0) {
            for(var i = 0; i < poLineItems.length; i++) {
                total += parseFloat(poLineItems[i].Quantity * poLineItems[i].Cost);
            }
        } 
        component.set("v.lineItemPopTotal", total);
    },
    handleRemoveLineItem : function(component, event, helper) {
        var index = event.target.dataset.index;
        console.log(index);
        var poLineItems = component.get("v.lineItems");
        poLineItems.splice(index, 1);
        component.set("v.lineItems", poLineItems); 
        var total = 0.00;
        if(poLineItems.length > 0) {
            for(var i = 0; i < poLineItems.length; i++) {
                total += parseFloat(poLineItems[i].Quantity * poLineItems[i].Cost);
            }
        }  
        component.set("v.lineItemPopTotal", total);
    },
    addPartsToPO : function(component, event, helper) {
        var lstLineItem = component.get("v.lineItems") != undefined ? component.get("v.lineItems") : [];
        if(lstLineItem.length > 0 && lstLineItem[lstLineItem.length - 1].PartNumber != '' && lstLineItem[lstLineItem.length - 1].Quantity > 0) {
            console.log(JSON.stringify(lstLineItem));
            var POLI = new Object();
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.Quantity = 0; 
            POLI.Cost = 0.00;  
            POLI.showPill = false;  
            lstLineItem.push(POLI);
            component.set("v.lineItems", lstLineItem);
        } else if(lstLineItem.length > 0) {
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
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.Quantity = 0; 
            POLI.Cost = 0.00;  
            POLI.showPill = false;
            lstLineItem.push(POLI);
            component.set("v.lineItems", lstLineItem);
        }
        
    },
    createPurchaseOrder : function(component, event, helper) {  
        console.log('>>>: ');
        var isError = false;
        var strLocation = component.find("opStoreLocation").get("v.value");
        var errorMessage = '';
        if(strLocation == null || strLocation == "")  {
            isError = true;
            errorMessage = 'Please select Store Location.';
        }
        var poLineItems = component.get("v.lineItems");
        if(poLineItems.length == 0) {
            isError = true;
            errorMessage = 'Please add some parts.';
        } else {
            if(poLineItems.length > 0 && (poLineItems[poLineItems.length - 1].PartNumber == '' || poLineItems[poLineItems.length - 1].Quantity <= 0)) {
                isError = true;
                errorMessage = "Please select the part and quantity should be greater than 0.";
            } 
        }
        if(!isError) { 
            component.find("refPurchaseOrder").submit();
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
    generateOrderJS : function(component, event, helper) {
        console.log("recordId", component.get("v.objRecId"));
    }
})