({
    doInit : function(component, event, helper){
        var action = component.get("c.isNoSalesmanWithoutCost");
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                component.set("v.NoSalesmanWithoutCost", res.getReturnValue());
            }
        });  
          
        $A.enqueueAction(action);
    },
    handleClick : function(component, event, helper) {
        console.log("Finish");
        document.getElementById("invSpinnerWiz").style.display= "block";
        var strProId = component.get("v.strProId");
        var ProductPriceIdList = component.get("v.ProductPriceIdList");
        var DealerOptionIdList = component.get("v.DealerOptionIdList");
        var DealerOptionList = component.get("v.lstDealerOptionWraper");
        var objInvEx = component.get("v.objInv");
        
        console.log(strProId);
        console.log(ProductPriceIdList);
        console.log(DealerOptionIdList);
        console.log(objInvEx);
        console.log(DealerOptionList);
        var action = component.get("c.generateInventory");
        action.setParams({
            "ProId": strProId,
            "lstProductPrice": ProductPriceIdList,
            "lstDealerOption": DealerOptionIdList,
            "objInventory": objInvEx,
            "lstDO": JSON.stringify(DealerOptionList)
        });
        action.setCallback(this, function(res) {
            //document.getElementById("invSpinnerWiz").style.display= "none";
            if(res.getState() == "SUCCESS" && res.getReturnValue() != null) {
                console.log(res.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                window.onbeforeunload = null;
                $A.get('e.force:refreshView').fire();
                urlEvent.setParams({
                    "url": '/'+res.getReturnValue()
                });
                urlEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    previousClick : function(component, event, helper) {
        var id_str = parseInt(5);
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
    HandelInvEvent: function(component, event, helper) {
        var objInventory = event.getParam("objInventory");
        var tab = event.getParam("tab");
        var objInvEx = component.get("v.objInv");
        
        console.log("Handel :");
        console.log(tab);
        console.log(objInventory);
        
        if(tab == "three") {
            objInvEx.BOATBUILDING__Order_Number_Text__c = objInventory.BOATBUILDING__Order_Number_Text__c;
            objInvEx.BOATBUILDING__Invoice_Number_Text__c = objInventory.BOATBUILDING__Invoice_Number_Text__c;
            objInvEx.BOATBUILDING__Engine_Year__c = objInventory.BOATBUILDING__Engine_Year__c;
            objInvEx.BOATBUILDING__Engine_Make__c = objInventory.BOATBUILDING__Engine_Make__c;
            objInvEx.BOATBUILDING__Engine_Model__c = objInventory.BOATBUILDING__Engine_Model__c;
            objInvEx.BOATBUILDING__Engine_SN__c = objInventory.BOATBUILDING__Engine_SN__c; 
            objInvEx.BOATBUILDING__Transmission_Gearbox_SN__c = objInventory.BOATBUILDING__Transmission_Gearbox_SN__c;
            objInvEx.BOATBUILDING__HIN_Number__c = objInventory.BOATBUILDING__HIN_Number__c;
            objInvEx.BOATBUILDING__Boat_Length_in_feets__c = objInventory.BOATBUILDING__Boat_Length_in_feets__c;
            objInvEx.BOATBUILDING__Trailer_VIN__c = objInventory.BOATBUILDING__Trailer_VIN__c;
            objInvEx.BOATBUILDING__Trailer_Year__c = objInventory.BOATBUILDING__Trailer_Year__c;
            objInvEx.BOATBUILDING__Trailer_Make__c = objInventory.BOATBUILDING__Trailer_Make__c;
            objInvEx.BOATBUILDING__Trailer_Model__c = objInventory.BOATBUILDING__Trailer_Model__c;
            objInvEx.BOATBUILDING__Trailer_Axles__c = objInventory.BOATBUILDING__Trailer_Axles__c;
            objInvEx.BOATBUILDING__Dealer_Boat_Stock__c = objInventory.BOATBUILDING__Dealer_Boat_Stock__c;
            objInvEx.BOATBUILDING__Dealer_Engine_Stock__c = objInventory.BOATBUILDING__Dealer_Engine_Stock__c;
            objInvEx.BOATBUILDING__Dealer_Trailer_Stock__c = objInventory.BOATBUILDING__Dealer_Trailer_Stock__c;
            console.log('objInventory.Dealer_Boat_Stock__c: '+objInventory.BOATBUILDING__Dealer_Boat_Stock__c);
            console.log('objInventory.Dealer_Engine_Stock__c: '+objInventory.BOATBUILDING__Dealer_Engine_Stock__c);
            console.log('objInventory.Dealer_Trailer_Stock__c: '+objInventory.BOATBUILDING__Dealer_Trailer_Stock__c);
        } else if(tab == "four") {
            objInvEx.BOATBUILDING__Costline__c = objInventory.BOATBUILDING__Costline__c;
            objInvEx.BOATBUILDING__Costline_Dollar__c = objInventory.BOATBUILDING__Costline_Dollar__c;
            objInvEx.BOATBUILDING__Total_MSRP_Price__c = objInventory.BOATBUILDING__Total_MSRP_Price__c;
            objInvEx.BOATBUILDING__Minimum_Sell_Price__c = objInventory.BOATBUILDING__Minimum_Sell_Price__c;
            objInvEx.BOATBUILDING__Suggested_List_Price__c = objInventory.BOATBUILDING__Suggested_List_Price__c;
        }
        component.set("v.objInv", objInvEx);
        
    }
})