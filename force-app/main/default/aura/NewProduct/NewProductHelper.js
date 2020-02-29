({
	getProductPrice : function(component, SelectedType, selectedManu, selectedYear, selectedModel, selectedModelVariant, MVStatus) {
		
        var action = component.get("c.getProductPriceApex");
        action.setParams({
            "SelectedType" : SelectedType,
            "selectedManu" : selectedManu,
            "selectedYear" : selectedYear,
            "selectedModel" : selectedModel,
            "selectedModelVariant" : selectedModelVariant,
            "MVStatus" : MVStatus
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                document.getElementById("toglSectionForNewORExProduct").style.display = "none";
                document.getElementById("PPSectionBBWizard").style.display = "block";
                document.getElementById("ExistigInvList").style.display = "none";
                document.getElementById("newInvCreate").style.display = "none";
                //component.set('v.newPLstPriceAndProductOptionWraperClass', res.getReturnValue());
                var cmpEvent = $A.get("e.c:ProductPriceEvent");
                
                cmpEvent.setParams({
                    "lstPriceAndProductOptionWraperClassPPE": res.getReturnValue()
                });
                cmpEvent.fire(); 
                
            }  
        }) 
        $A.enqueueAction(action);
        
        
        
        var action1 = component.get("c.getDealerPriceApex");
        action1.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                //component.set('v.newPLstPriceAndProductOptionWraperClass', res.getReturnValue());
                var cmpEvent = $A.get("e.c:DealerOptionEvent");
                
                cmpEvent.setParams({
                    "newPLstDealerOptionWraper": res.getReturnValue()
                });
                cmpEvent.fire(); 
                
            }  
        }) 
        $A.enqueueAction(action1);
        
	},
    getProductPricing: function(component, event, ProductId) {
        console.log('ProductId: '+ProductId);
        var action = component.get("c.getProduct");
        action.setParams({
            "ProId" : ProductId
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                
                var cmpEvent = $A.get("e.c:ProductPriceForPaymentCalculator");
                
                cmpEvent.setParams({
                    "objProduct": res.getReturnValue()
                });
                cmpEvent.fire(); 
                
            }  
        }) 
        $A.enqueueAction(action);
    }
})