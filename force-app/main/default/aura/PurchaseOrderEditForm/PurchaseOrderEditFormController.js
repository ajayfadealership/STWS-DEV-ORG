({
    doInit : function(component, event, helper) {
        console.log('objRecId: '+component.get("v.objRecId"));
        var recId = component.get("v.objRecId");
        if(recId != '' && recId != null && recId != undefined) {
            console.log("Call Check");
            helper.getLineItemHelper(component, recId); 
        } 
        var action = component.get("c.getPORecordTypeId");
        action.setCallback(this, function(response){
            console.log("Response: "+response.getReturnValue());
            component.set("v.poRecordTypeId", response.getReturnValue());
        }); 
        $A.enqueueAction(action);
        if(component.get("v.objRecId") != '' && component.get("v.objRecId") != null){
            helper.fetchManuHelper(component, event, '', component.get("v.objRecId"));
        }
      
    },
    
    handleLoad : function(component, event, helper) { }
    ,
    handleSubmit : function(component, event, helper) { } 
    ,
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
       
        if(payload.id != undefined && payload.id != null) {
            var poLineItems = component.get("v.lineItems");
             console.log('>>>>>>%%%'+JSON.stringify(poLineItems));
            var action = component.get("c.updatePOwithLineItems");
            action.setParams({
                "strPOId" : payload.id,
                "strLineItems" : JSON.stringify(poLineItems)
            });
            action.setCallback(this, function(response){
                console.log("Response: "+response.getReturnValue());
                if(response.getReturnValue() == 'SUCCESS') {
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({ 
                        "type" : "success",
                        "title": "Success!",
                        "message": "Purchase Order Successfully Created."
                    });
                    errorEvent.fire(); 
                    if(component.get("v.objRecId") == null || component.get("v.objRecId") == "" || component.get("v.objRecId") == undefined) {
                        //component.set("v.showform", false);
                        //component.set("v.showlist", true); 
                        var urlEvent = $A.get("e.force:navigateToURL");
                        var urlStr = "/"+payload.id;
                        urlEvent.setParams({
                            "url": urlStr
                        });
                        urlEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    } else {
                        helper.getLineItemHelper(component, component.get("v.objRecId"));
                    }
                    
                } else {
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
        }
    },
    handleError: function(component, event, helper) {
        console.log('handleError'); 
        console.log(JSON.stringify(event.getParams()));
        console.log(JSON.stringify(event.getParams('detail'))); 
        var errorEvent = $A.get("e.force:showToast");
        errorEvent.setParams({
            "type" : 'error', 
            "title": "Error!",
            "message": JSON.stringify(event.getParams('detail'))
        }); 
        errorEvent.fire();
    },
    showPOList : function(component, event, helper) { 
        component.set("v.showform", false);
		component.set("v.showlist", true);
    },
    fetchManuDetails : function(component, event, helper) {
        var manuId = component.find("opVendorName").get("v.value");
      
        console.log('manuId',manuId[0]);
        if(typeof manuId != "undefined" && manuId.length > 0)
        manuId = manuId[0];
        if(manuId != null && manuId != undefined && manuId != '') {
            
            helper.fetchManuHelper(component, event, manuId, '');
        } else {
            component.set("v.objManu", {'sobjectType': 'BOATBUILDING__Manufacturer__c'});
            component.set("v.showSpinner", false);
        }
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
            POLI.SortingOrder = '';
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
            POLI.SortingOrder = '';
            lstLineItem.push(POLI);
            component.set("v.lineItems", lstLineItem);
        }
        
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
        var action = component.get("c.generateOrderApex");
        action.setParams({
            "strRecId" : component.get("v.objRecId")
        });
        action.setCallback(this, function(response) {
            if(response.getReturnValue().includes("Error")) {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            } else {
                var urlEvent = $A.get("e.force:navigateToURL");
                var urlStr = "/"+response.getReturnValue();
                urlEvent.setParams({
                    "url": urlStr
                });
                urlEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    }
})