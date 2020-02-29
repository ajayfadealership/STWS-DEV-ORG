({
    getProductPrice : function(component, SelectedType, selectedManu, selectedYear, selectedModel, selectedModelVariant, MVStatus) {
         console.log("Second");
        document.getElementById("invSpinnerWiz").style.display= "block";
        //console.log(document.getElementById("invSpinnerWiz").style.display + '---');
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
            document.getElementById("invSpinnerWiz").style.display= "none";
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                if(document.getElementById("toglSectionForNewORExProduct") != null)
                    document.getElementById("toglSectionForNewORExProduct").style.display = "none";
                if(document.getElementById("PPSectionBBWizard") != null)
                    document.getElementById("PPSectionBBWizard").style.display = "block";
                if(document.getElementById("ExistigInvList") != null)
                    document.getElementById("ExistigInvList").style.display = "none";
                if(document.getElementById("newInvCreate") != null)
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
            var id_str = parseInt(1);
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
            document.getElementById("invSpinnerWiz").style.display= "none";
            if(state == 'SUCCESS') { 
                /*var action = component.get("c.getProduct");
                action.setParams({
                    "ProId" : component.get("v.ProductIdTOSearch")
                });
                action.setCallback(this, function(res) {
                    var state = res.getState();
                    console.log(res.getReturnValue().BOATBUILDING__M_Boat_MSRP_PRICE__c);
                    console.log("PPP");
                    if(state == 'SUCCESS') {
                    
                    }
                });
                $A.enqueueAction(action);*/
                
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
        //document.getElementById("invSpinnerWiz").style.display= "none";
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
                if(res.getReturnValue().BOATBUILDING__Default_Costline__c != undefined) {
                    var cmpEvent = $A.get("e.c:InvCostLineEvent");
                    cmpEvent.setParams({
                        "costlinePoint": parseFloat(res.getReturnValue().BOATBUILDING__Default_Costline__c)
                    }); 
                    cmpEvent.fire();
                }
            }  
        }) 
        $A.enqueueAction(action);
    }
})