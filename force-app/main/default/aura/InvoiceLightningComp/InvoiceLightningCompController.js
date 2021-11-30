({
    
    doInit : function(component, event, helper) {   
        component.set("v.Spinner", true); 
        var recId = component.get("v.recordId");
        if(recId != '' && recId != null && recId != undefined) {
            
            helper.getLineItemHelper(component, recId);  
            
        } 
        var action = component.get("c.InvRecordTypeId");
        action.setParams({
            "RecordId" : recId != undefined? recId : ''
        });
        action.setCallback(this, function(response){
            component.set("v.Spinner", false); 
            component.set("v.InvRecordTypeId", response.getReturnValue().Id);
            component.set("v.RecordTypeName", response.getReturnValue().Name);
            var recordType = component.get('v.RecordTypeName');
            if(recordType == 'Web Invoices') {
                var salesTaxAction = component.get("c.getwebSalestax"); 
                salesTaxAction.setParams({
                    "invId" : component.get("v.recordId")
                });  
                salesTaxAction.setCallback(this, function(responsess){
                    if(responsess.getState() == "SUCCESS" 
                       && responsess.getReturnValue() != undefined 
                       && responsess.getReturnValue() != null){
                        component.set("v.salesTaxAmountWeb", responsess.getReturnValue());
                    }  
                });    
                $A.enqueueAction(salesTaxAction);
            }
            
        }); 
        $A.enqueueAction(action);
        
        var getSalesTax = component.get("c.getSalesTaxCustomSetting"); 
        getSalesTax.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                component.set("v.salesTaxConfig", response.getReturnValue());
                helper.calculateInvoiceTotalHelper(component, event, helper);
                var recordType = component.get('v.RecordTypeName');
                if(recordType == 'Web Invoices') {
                    helper.calculateTotalWebInvoice(component); 
                }
            }
        }); 
        $A.enqueueAction(getSalesTax);
      if(component.get("v.recordId") != null && component.get("v.recordId") != ''){
        var getdiscount = component.get("c.getdiscount"); 
        getdiscount.setParams({
            "recId" :  component.get("v.recordId")
        });
        getdiscount.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.totalValue", "v.invoiceGrandTotal");
                component.set("v.discountOnInvoice",result.BOATBUILDING__Discount_on_Invoice__c);
            }
        }); 
        $A.enqueueAction(getdiscount); 
    }

        helper.getAccountRecordTypeId(component);  
        
        
        var fetchPayment = component.get("c.getAllPayment");
        fetchPayment.setParams({
            "srtInvId" :  component.get("v.recordId")
        });
        fetchPayment.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                var result  = response.getReturnValue();
                
                component.set("v.payment",response.getReturnValue());
                //  alert(result);
            }
        }); 
        $A.enqueueAction(fetchPayment);

       
        
        
    },
    addParts : function(component, event, helper) {
        console.log('call');
        component.set("v.showTotal", true);
        
        var lstLineItem = component.get("v.items") != undefined ? component.get("v.items") : [];
        if(lstLineItem.length > 0 && ( lstLineItem[lstLineItem.length - 1].PartNumber != ''  || lstLineItem[lstLineItem.length - 1].isMISC == true   ) && lstLineItem[lstLineItem.length - 1].QuantityDec != 0) {
            var POLI = new Object();
            POLI.PartId = '';
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.QuantityDec = 1; 
            POLI.Cost = 0.00; 
            POLI.partMSRP = 0.00; 
            POLI.discountPer = 0.00;
            POLI.TotalWithoutDisc = 0.00;
            POLI.discount = 0.00;
            POLI.isDisabled=true;
            POLI.isMISC= false;
            POLI.SortingOrder = '';
            lstLineItem.push(POLI);
            component.set("v.items", lstLineItem);
        }else if(lstLineItem.length > 0) {
            //alert('inside else if  ');
            if(lstLineItem[lstLineItem.length - 1].isMISC ==  false && lstLineItem[lstLineItem.length - 1].PartId == ''){
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error", 
                    "title": "Error!",
                    "message": "Please select a valid part or use Add Misc part button."
                });
                errorEvent.fire();
            }else if(lstLineItem[lstLineItem.length - 1].QuantityDec == 0){
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error", 
                    "title": "Error!",
                    "message": "Part's quantity should be greater or smaller than 0."
                });
                errorEvent.fire();
            }
            
        } else {
            var POLI = new Object();
            POLI.PartId = '';
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.QuantityDec = 0; 
            POLI.discountPer = 0.00;
            POLI.discount = 0.00;
            POLI.Cost = 0.00;
            POLI.isDisabled=true;
            POLI.isMISC= false;
            POLI.TotalWithoutDisc = 0.00; 
            POLI.SortingOrder = '';
            lstLineItem.push(POLI);
            component.set("v.items", lstLineItem);
        }
        
        
    },
    addMiscParts : function(component, event, helper) {
        component.set("v.showTotal", true);
        var lstLineItem = component.get("v.items") != undefined ? component.get("v.items") : [];
        if(lstLineItem.length > 0 && ( lstLineItem[lstLineItem.length - 1].PartNumber != ''  || lstLineItem[lstLineItem.length - 1].isMISC == true ) && lstLineItem[lstLineItem.length - 1].QuantityDec != 0){
            var POLI = new Object();
            POLI.PartId = '';
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.QuantityDec = 1; 
            POLI.Cost = 0.00; 
            POLI.partMSRP = 0.00; 
            POLI.discountPer = 0.00;
            POLI.TotalWithoutDisc = 0.00;
            POLI.discount = 0.00;
            POLI.isMISC= true;
            POLI.isDisabled= false;
            POLI.SortingOrder = '';
            lstLineItem.push(POLI);
            component.set("v.items", lstLineItem);
        }else if(lstLineItem.length > 0) {
            if(lstLineItem[lstLineItem.length - 1].isMISC ==  false && lstLineItem[lstLineItem.length - 1].PartId == ''){
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error", 
                    "title": "Error!",
                    "message": "Please select a valid part or use Add Misc part button."
                });
                errorEvent.fire();
            }else if(lstLineItem[lstLineItem.length - 1].QuantityDec == 0){
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error", 
                    "title": "Error!",
                    "message": "Part's quantity should be greater or smaller than 0."
                });
                errorEvent.fire();
            }
        } else {
            var POLI = new Object();
            POLI.PartId = '';
            POLI.PartNumber = ''; 
            POLI.PartName = ''; 
            POLI.QuantityDec = 0; 
            POLI.discountPer = 0.00;
            POLI.discount = 0.00;
            POLI.Cost = 0.00;
            POLI.isMISC= true;
            POLI.isDisabled= false;
            POLI.TotalWithoutDisc = 0.00; 
            POLI.SortingOrder = '';
            lstLineItem.push(POLI);
            component.set("v.items", lstLineItem);
        }
        
        
    },
    handleRemoveLineItem : function(component, event, helper) {
        component.set("v.Spinner", true); 
        var index = event.target.dataset.index;
        var value = event.target.dataset.value;
        var poLineItems = component.get("v.items");
        poLineItems.splice(index, 1);
        
        component.set("v.items", poLineItems); 
        var total = 0.00;
        if(poLineItems.length > 0) {
            for(var i = 0; i < poLineItems.length; i++) {
                total += parseFloat(poLineItems[i].QuantityDec * poLineItems[i].Cost);
            }
        }
        component.set("v.Spinner", false); 
        if(typeof value != "undefined" && value != null){
            component.set("v.Spinner", true); 
            var action = component.get("c.deleteInvoiceLineItem");
            action.setParams({
                "invoiceLineItemId" : value
            });
            action.setCallback(this, function(response){
                component.set("v.Spinner", false); 
                var state = response.getState();
                if(state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "This item has been removed.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();   
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There was an error. Please try again.",
                        "type":"error"
                    });
                    toastEvent.fire();
                    component.set("v.Spinner", false); 
                }
                
            });
            $A.enqueueAction(action);
        }
        
        component.set("v.lineItemPopTotal", total);
    },
    backToList: function(component, event, helper) {
        component.set("v.showform", false);
        component.set("v.showlist", true);
    },
    submitForm : function(component, event, helper){
        var LineItems =  component.get("v.items");
        var hasError = false;
        if(LineItems.length > 0) {
            for(var i= 0 ; i <  LineItems.length; i++){
                if(typeof LineItems[i] != "undefined" && (LineItems[i].PartName == '' || LineItems[i].PartName == null)){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "The Part Name can't be blank.",
                        "type":"error"
                    });
                    toastEvent.fire();
                    event.preventDefault();
                    hasError = true;
                }
                if(typeof LineItems[i] != "undefined" && (LineItems[i].discount < 0 || LineItems[i].discountPer < 0)){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Discount can not be negetive",
                        "type":"error"
                    });
                    toastEvent.fire();
                    event.preventDefault();
                    hasError = true;
                }
                
                
            }
            
            
            
        }
        if(hasError == false){
            component.set("v.Spinner", true); 
        }
        
    },
    handleSuccess: function(component, event, helper) {
        
        
        
        var acc = component.get("v.ObjAccount");
        if(!component.get("v.toggleValue") && acc.Name != null && acc.Name != '') {
            var payload = event.getParams().response;
            if(payload.id != undefined && payload.id != null) {
                var poLineItems = component.get("v.items");
                var action = component.get("c.UpdateInvoicewithLineItems");
                action.setParams({ 
                    "strInvId" : payload.id,
                    "strLineItems" : JSON.stringify(poLineItems),
                    "objA" : component.get("v.ObjAccount")
                });
                action.setCallback(this, function(response){ 
                    component.set("v.Spinner", false); 
                    if(response.getReturnValue() == 'SUCCESS') {
                        var errorEvent = $A.get("e.force:showToast");
                        errorEvent.setParams({ 
                            "type" : "success",
                            "title": "Success!",
                            "message": "Invoice Successfully Updated."
                        });
                        errorEvent.fire(); 
                        $A.get('e.force:refreshView').fire();   
                        //$A.get("e.force:closeQuickAction").fire();
                        if(component.get("v.recordId") == null || component.get("v.recordId") == "" || component.get("v.recordId") == undefined) {
                            //component.set("v.showform", false);
                            //component.set("v.showlist", true); 
                            //var urlEvent = $A.get("e.force:navigateToURL");
                            var navLink = component.find("navService");
                            var pageRef = {
                                type: 'standard__recordPage',
                                attributes: {
                                    actionName: 'view',
                                    objectApiName: 'BOATBUILDING__Invoice__c',
                                    recordId : payload.id
                                },
                            };
                            navLink.navigate(pageRef, false);
                            
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
        }else{
            
            if(!component.get("v.toggleValue")){
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": "Please fill Account Name"
                });
                errorEvent.fire();
                component.set("v.Spinner", false); 
            }
            
            
        }
        
        var AccountLookup = component.get("v.AccountId") ;
        if(component.get("v.toggleValue") == true && AccountLookup != null && AccountLookup != undefined  && component.get("v.AccountId") !=  "" &&
           (component.get("v.recordId") == null || component.get("v.recordId") == "" || component.get("v.recordId") == undefined)){
            var payload = event.getParams().response;
            if(payload.id != undefined && payload.id != null) {
                var poLineItems = component.get("v.items");
                var action = component.get("c.UpdateInvoicewithLineItemsWithSelectedAccount");
                
                action.setParams({ 
                    "strInvId" : payload.id,
                    "strLineItems" : JSON.stringify(poLineItems)
                });
                action.setCallback(this, function(response){ 
                    component.set("v.Spinner", false); 
                    if(response.getReturnValue() == 'SUCCESS') {
                        var errorEvent = $A.get("e.force:showToast");
                        errorEvent.setParams({ 
                            "type" : "success",
                            "title": "Success!",
                            "message": "Invoice Successfully Updated."
                        });
                        errorEvent.fire(); 
                        $A.get('e.force:refreshView').fire();   
                        //$A.get("e.force:closeQuickAction").fire();
                        if(component.get("v.recordId") == null || component.get("v.recordId") == "" || component.get("v.recordId") == undefined) {
                            //component.set("v.showform", false);
                            //component.set("v.showlist", true); 
                            //var urlEvent = $A.get("e.force:navigateToURL");
                            var navLink = component.find("navService");
                            var pageRef = {
                                type: 'standard__recordPage',
                                attributes: {
                                    actionName: 'view',
                                    objectApiName: 'BOATBUILDING__Invoice__c',
                                    recordId : payload.id
                                },
                            };
                            navLink.navigate(pageRef, false);
                            
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
                
                
                
            }
            
            
        }else{
            if(component.get("v.toggleValue") && component.get("v.recordId") == null ){
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": 'Please Select Account'
                });
                component.set("v.Spinner", false);
                errorEvent.fire();
                
                
            }
            
        }
        
        
        
        if( component.get("v.recordId") != null && component.get("v.recordId") != "" && component.get("v.recordId") != undefined ){
            var payload = event.getParams().response;
            
            if(payload.id != undefined && payload.id != null) { 
                var poLineItems = component.get("v.items");
                var action = component.get("c.UpdateInvoicewithLineItemsWithSelectedAccount");
                
                
                action.setParams({ 
                    "strInvId" : payload.id,
                    "strLineItems" : JSON.stringify(poLineItems)
                });
                action.setCallback(this, function(response){ 
                    component.set("v.Spinner", false); 
                    if(response.getReturnValue() == 'SUCCESS') {
                        var errorEvent = $A.get("e.force:showToast");
                        errorEvent.setParams({ 
                            "type" : "success",
                            "title": "Success!",
                            "message": "Invoice Successfully Updated."
                        });
                        errorEvent.fire(); 
                        $A.get('e.force:refreshView').fire();   
                        //$A.get("e.force:closeQuickAction").fire();
                        if(component.get("v.recordId") == null || component.get("v.recordId") == "" || component.get("v.recordId") == undefined ) {
                            //component.set("v.showform", false);
                            //component.set("v.showlist", true); 
                            //var urlEvent = $A.get("e.force:navigateToURL");
                            var navLink = component.find("navService");
                            var pageRef = {
                                type: 'standard__recordPage',
                                attributes: {
                                    actionName: 'view',
                                    objectApiName: 'BOATBUILDING__Invoice__c',
                                    recordId : payload.id
                                },
                            };
                            navLink.navigate(pageRef, false);
                            
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
                
                
                
            } 
            
            
            
            
            
            
            
        } 
        
        
    },
    
    
    calculateInvoiceTotal : function(component, event, helper) {
        helper.calculateInvoiceTotalHelper(component, helper, event);
        var recordType = component.get('v.RecordTypeName');
        if(recordType == 'Web Invoices') {
            console.log('Check ',recordType);
            helper.calculateTotalWebInvoice(component); 
        }
    },
    
    submitInv : function(component, event, helper) {  
        var strLocation = component.find("storeLocId").get("v.value");
        var isError = false;
        var errorMessage = '';
        if(strLocation == null || strLocation == "")  {
            isError = true;
            errorMessage = 'Please select Store Location.';
        }
        var LineItems = component.get("v.items");
        if(LineItems.length == 0) {
            isError = true;
            errorMessage = 'Please add some parts.';
        } else {
            if(LineItems.length > 0 && LineItems[LineItems.length - 1].PartNumber == '') {
                isError = true;
                errorMessage = "Please select the part";
            } 
        }
        var soldBy = component.find("soldById").get("v.value");
        isError = false;
        errorMessage = '';
        if(soldBy == null || soldBy == "")  {
            isError = true;
            errorMessage = 'Please add Sold By.';
        }
        if(!isError) { 
            component.set('v.showSpinner',true);
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
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
        
    },
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
        
        
    },
    calculateGrandTotal : function(component, event, helper){
        component.set("v.Spinner", false); 
        helper.calculateInvoiceTotalHelper(component, helper, event);
        var salesTaxObject =  JSON.parse(component.get("v.salesTaxConfig"));
        var recordType = component.get("v.RecordTypeName")
        var salesTax = 0.00;
        var salesTaxPercent = 0.00;
        if(salesTaxObject != null && typeof salesTaxObject != "undefined"){
            var state = component.find("billingState");
            if(typeof state != "undefined"){
                var bState = state.get("v.value");
                var salesTaxSetting = salesTaxObject[bState];
                if(typeof salesTaxSetting != "undefined"){
                    if(recordType == 'Web Invoices') {
                        if(salesTaxSetting.BOATBUILDING__Web_Invoice_Taxable__c != undefined && salesTaxSetting.BOATBUILDING__Web_Invoice_Taxable__c) {
                            salesTaxPercent = salesTaxSetting.BOATBUILDING__Regular_Sales_Tax__c;
                        }
                    } else {
                        salesTaxPercent = salesTaxSetting.BOATBUILDING__Regular_Sales_Tax__c;
                    }
                    
                }
            }
        }
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
        var salesTax = (parseFloat(partTotal)/100)  * salesTaxPercent;
        component.set("v.salesTaxAmount",salesTax);
        var invdiscount = component.get('v.discountOnInvoice') ;
        var discountInv = component.find("disctId").get("v.value");
        var grandTotal = parseFloat(partTotal) + parseFloat(shippingCharge) + salesTax - invdiscount ;
        var recordType = component.get('v.RecordTypeName');
        if(recordType == 'Web Invoices') {
            helper.calculateTotalWebInvoice(component); 
        }
    },
    onClick : function(component, event, helper) {
        
        var changeElement = component.find("submit");
        //$A.util.toggleClass(changeElement, "slds-hide");
        
        if(component.get("v.toggleValue") == true){
            component.set("v.ShowAcc",false);
            component.set("v.ShowAccLookup",true);
            
        }
        if(component.get("v.toggleValue") == false){
            component.set("v.ShowAcc",true);
            component.set("v.ShowAccLookup",false);
            
            
        }
        
        
    },
    webSalestaxUpdate: function(component, event, helper) {
        console.log(component.get("v.salesTaxAmountWeb"));
        helper.calculateTotalWebInvoice(component); 
    },

    onchangeOfdiscount : function(component, event, helper) {
        let invoiceGrandTotalWithoutDis = parseFloat(component.get("v.invTotal"));
        var discount = component.get("v.discountOnInvoice");
        console.log('discount : '+discount);
        console.log('invoiceGrandTotalWithoutDis : '+invoiceGrandTotalWithoutDis);
        if(discount){
            //var grandTotal = component.get("v.invoiceGrandTotal");
            component.set("v.invoiceGrandTotal" , invoiceGrandTotalWithoutDis - discount); 
        }else{
            component.set("v.invoiceGrandTotal" , invoiceGrandTotalWithoutDis); 
        }
    },
    
    handleShowActiveSectionName: function (cmp, event, helper) {
        console.log(cmp.find("accordion").get('v.activeSectionName'));
    },
    handleSetActiveSectionC: function (cmp) {
        cmp.find("accordion").set('v.activeSectionName', 'C');
    }
    /*  handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        component.set("v.Spinner", true); 
        var fields = event.getParam('fields');
        component.find('AccId').submit(fields);
    }, */
    /*   handleAccountSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; 
      //  alert(myRecordId);
      
       if(myRecordId != null && myRecordId != ''){
        component.set("v.Spinner", true); 
        var getRelatedContact = component.get("c.getAccountRelatedCon"); 
        getRelatedContact.setParams({
            "AccId" : myRecordId
           
        });
        getRelatedContact.setCallback(this, function(response) {
           
            if(response.getState() == "SUCCESS") 
            {   
                var result = response.getReturnValue();
               // alert(JSON.stringify(response.getReturnValue()));
               
                component.set("v.objcontact",response.getReturnValue());
                component.set("v.ConId",result.Id);
                component.set("v.toggleValue",true);
                component.set("v.ShowAcc",false);
                component.set("v.Spinner", true);
                component.set("v.Spinner", false);  
              
               
                }
               
                });
               
                    $A.enqueueAction(getRelatedContact);
                   

                   
            }
    
           
    } */
})