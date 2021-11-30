({
	calculateTotal : function(component, event) {
        console.log('>>>newPLstPriceAndProductOptionWraperClass: ', component.get("v.newPLstPriceAndProductOptionWraperClass"));
        var pplist = component.get("v.newPLstPriceAndProductOptionWraperClass");
        var selectedppList = component.get("v.ProductPriceIdListCCC");
        console.log('>>>ProductPriceIdListCCC: ', component.get("v.ProductPriceIdListCCC"));
        var MSRPDealerPrice = parseFloat(component.get("v.ProductDealerPrice"));
        var MSRPRetailPrice = parseFloat(component.get("v.ProductRetailPrice"));
        var mfgRetail = 0.00;
        var mfgDealer = 0.00;  
        for(var i = 0; i < pplist.length; i++) {
            if(pplist[i].lstProductPriceForSelectedCategory.length > 0) {
                var lstPPSC = pplist[i].lstProductPriceForSelectedCategory;
                for(var j = 0; j < lstPPSC.length; j++) {
                    if(selectedppList.includes(lstPPSC[j].objProductPriceForSelectedCategory.Id)) {
                        var objPP = lstPPSC[j];
                        var ppQuantity1 = objPP.objProductPriceForSelectedCategory.BOATBUILDING__Quantity__c != undefined &&  objPP.objProductPriceForSelectedCategory.BOATBUILDING__Quantity__c != '' ? 
                                                parseFloat(objPP.objProductPriceForSelectedCategory.BOATBUILDING__Quantity__c) : 0;
                        console.log('objPP.objProductPriceForSelectedCategory.BOATBUILDING__Quantity__c: ', objPP.objProductPriceForSelectedCategory.BOATBUILDING__Quantity__c);
                        mfgDealer += parseFloat(objPP.objProductPriceForSelectedCategory.BOATBUILDING__Dealer_Price__c * ppQuantity1);
                        mfgRetail += parseFloat(objPP.objProductPriceForSelectedCategory.BOATBUILDING__ProductRetail_Price__c * ppQuantity1);
                    }
                }
            }
        }
        console.log(mfgDealer);
        console.log(mfgRetail);
        component.set("v.MfgOptionDealerPrice", mfgDealer);
        component.set("v.MfgOptionRetailPrice", mfgRetail);
        MSRPDealerPrice += mfgDealer;
        MSRPRetailPrice += mfgRetail;  
        console.log(MSRPDealerPrice);
        console.log(MSRPRetailPrice);
        component.set('v.TotalMSRPDealerPrice', parseFloat(MSRPDealerPrice).toFixed(2));
        component.set('v.TotalMSRPRetailPrice', parseFloat(MSRPRetailPrice).toFixed(2));
        console.log('v.TotalMSRPRetailPrice>>>: ', component.get('v.TotalMSRPRetailPrice'));
        if(MSRPDealerPrice != undefined) {
            console.log("MSRPDealerPrice: "+MSRPDealerPrice);
            //alert(component.get("v.PrntAtt"));
            if(component.get("v.PrntAtt") == 'Inventory') {
                var cmpEvent = $A.get("e.c:InvMSRPEvent");
                cmpEvent.setParams({ 
                    "msrp": MSRPDealerPrice
                }); 
                cmpEvent.fire();
            }
        }
        if(MSRPDealerPrice != undefined) {
            //alert(component.get("v.PrntAtt"));
            if(component.get("v.PrntAtt") == 'Inventory') {
                var cmpEvent = $A.get("e.c:InvDealerPriceEvent");
                cmpEvent.setParams({ 
                    "msrp": MSRPDealerPrice
                });
                cmpEvent.fire();
            }
        }
	}
})