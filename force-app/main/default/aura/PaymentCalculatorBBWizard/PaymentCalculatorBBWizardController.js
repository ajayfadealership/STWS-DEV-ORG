({
    HandelPPFPCEvent : function(component, event, helper) {
        var retMessagePP = event.getParam("objProduct");
        console.log(retMessagePP);
        
        component.set('v.ProductDealerPrice', parseFloat(retMessagePP.BOATBUILDING__Cost_Price__c).toFixed(2)  );
        component.set('v.ProductRetailPrice', parseFloat(retMessagePP.BOATBUILDING__M_Boat_MSRP_PRICE__c).toFixed(2) );
        var totalMSRP = retMessagePP.BOATBUILDING__M_Boat_MSRP_PRICE__c;
        var totalDealerCost = retMessagePP.BOATBUILDING__Cost_Price__c;
        component.set("v.MfgOptionDealerPrice", 0.00);
        component.set("v.MfgOptionRetailPrice", 0.00);
        
        //var DODP = component.get("v.DlrOptionDealerPrice");
        //var DPRP = component.get("v.DlrOptionRetailPrice");
        
        component.set("v.DlrOptionDealerPrice", 0.00);
        component.set("v.DlrOptionRetailPrice", 0.00); 
        component.set('v.TotalMSRPDealerPrice', parseFloat(totalDealerCost).toFixed(2));
        component.set('v.TotalMSRPRetailPrice', parseFloat(totalMSRP).toFixed(2));
        if(totalMSRP != undefined) {
            //alert(component.get("v.PrntAtt"));
            if(component.get("v.PrntAtt") == 'Inventory') {
                var cmpEvent = $A.get("e.c:InvMSRPEvent");
                cmpEvent.setParams({ 
                    "msrp": totalMSRP
                });
                cmpEvent.fire();
            }
        }
        
        if(totalDealerCost != undefined) {
            //alert(component.get("v.PrntAtt"));
            if(component.get("v.PrntAtt") == 'Inventory') {
                var cmpEvent = $A.get("e.c:InvDealerPriceEvent");
                cmpEvent.setParams({ 
                    "msrp": totalDealerCost
                });
                cmpEvent.fire();
            }
        }
    },
    HandelPPIdEvent : function(component, event, helper) {
        var PPId = event.getParam("PPID");
        var PPStatus = event.getParam("PPStatus");
        console.log(PPId + ' : ' + PPStatus);
        
        if(PPId != undefined) {
            //alert(PPId);
            var action = component.get("c.getPPDetails");
            action.setParams({
                "PPid": PPId
            });
            //alert(PPId+'  2');
            action.setCallback(this, function(res) {
                var state = res.getState();
                console.log(res.getReturnValue());  
                if(state == 'SUCCESS') {
                    var mfgDealerPrice = parseFloat(res.getReturnValue().BOATBUILDING__Dealer_Price__c);
                    var mfgRetailPrice = parseFloat(res.getReturnValue().BOATBUILDING__ProductRetail_Price__c);
                    var mfgDealerPriceEX = parseFloat(component.get("v.MfgOptionDealerPrice"));
                    var mfgRetailPriceEX = parseFloat(component.get("v.MfgOptionRetailPrice"));
                    var TotalMSRPDealerPriceEX = parseFloat(component.get("v.TotalMSRPDealerPrice"));
                    var TotalMSRPRetailPriceEX = parseFloat(component.get("v.TotalMSRPRetailPrice"));
                    console.log(mfgDealerPriceEX);
                    console.log(mfgRetailPriceEX);
                    console.log(TotalMSRPDealerPriceEX);
                    console.log(TotalMSRPRetailPriceEX);
                    if(PPStatus == '1') { 
                        mfgDealerPriceEX += mfgDealerPrice;
                        mfgRetailPriceEX += mfgRetailPrice;
                        TotalMSRPDealerPriceEX += mfgDealerPrice;
                        TotalMSRPRetailPriceEX += mfgRetailPrice;
                    } else if(PPStatus == '0') {
                        mfgDealerPriceEX -= mfgDealerPrice;
                        mfgRetailPriceEX -= mfgRetailPrice;
                        TotalMSRPDealerPriceEX -= mfgDealerPrice;
                        TotalMSRPRetailPriceEX -= mfgRetailPrice;
                    }
                    console.log(mfgDealerPriceEX);
                    console.log(mfgRetailPriceEX);
                    console.log(TotalMSRPDealerPriceEX);
                    console.log(TotalMSRPRetailPriceEX);
                    component.set("v.MfgOptionDealerPrice", parseFloat(mfgDealerPriceEX).toFixed(2));
                    component.set("v.MfgOptionRetailPrice", parseFloat(mfgRetailPriceEX).toFixed(2));
                    component.set('v.TotalMSRPDealerPrice', parseFloat(TotalMSRPDealerPriceEX).toFixed(2));
                    component.set('v.TotalMSRPRetailPrice', parseFloat(TotalMSRPRetailPriceEX).toFixed(2));
                    //alert(PPId+'  3');
                    if(TotalMSRPRetailPriceEX != undefined) {
                        console.log("TotalMSRPRetailPriceEX: "+TotalMSRPRetailPriceEX);
                        //alert(component.get("v.PrntAtt"));
                        if(component.get("v.PrntAtt") == 'Inventory') {
                            var cmpEvent = $A.get("e.c:InvMSRPEvent");
                            cmpEvent.setParams({ 
                                "msrp": TotalMSRPRetailPriceEX
                            }); 
                            cmpEvent.fire();
                        }
                    }
                    if(TotalMSRPDealerPriceEX != undefined) {
                        //alert(component.get("v.PrntAtt"));
                        if(component.get("v.PrntAtt") == 'Inventory') {
                            var cmpEvent = $A.get("e.c:InvDealerPriceEvent");
                            cmpEvent.setParams({ 
                                "msrp": TotalMSRPDealerPriceEX
                            });
                            cmpEvent.fire();
                        }
                    }
                }  
            }); 
            $A.enqueueAction(action);
        }
    },
    HandelPPDOIdEvent: function(component, event, helper) {
        var objDO = event.getParam("objDOId");
        console.log(objDO); 
        var PPStatus = event.getParam("PPStatus");
        var DoListCo = event.getParam("DOList");
        var DOListAll = event.getParam("DealerOptionWraper");
        console.log('DOListAll');
        console.log(DOListAll);
        var PPId = event.getParam("PPID");
        var PPStatus = event.getParam("PPStatus");
        console.log(PPId + ' : ' + PPStatus);
        
        var TotalMSRPDealerPriceEX = 0.00;
        var TotalMSRPRetailPriceEX = 0.00;
        var TotalMFGMSRPDealerPrice = parseFloat(component.get("v.MfgOptionDealerPrice"));
        var TotalMFGMSRPRetailPrice = parseFloat(component.get("v.MfgOptionRetailPrice"));
        var MSRPDealerPrice = parseFloat(component.get("v.ProductDealerPrice"));
        var MSRPRetailPrice = parseFloat(component.get("v.ProductRetailPrice"));
        var mfgDealerPrice = 0.00;
        var mfgRetailPrice = 0.00;
        if(DOListAll.length > 0) {
            for(var i = 0; i < DOListAll.length; i++) {
                if(DOListAll[i].isSelect) {
                    console.log(DOListAll[i]);
                    var objj = DOListAll[i].objDealerOption;
                    console.log(objj);  
                    var dp = parseFloat(objj.BOATBUILDING__Cost__c);
                    var rp = parseFloat(objj.BOATBUILDING__Retail_Price__c);        
                    console.log('>>:');
                    console.log(dp);
                    console.log(rp);
                    mfgDealerPrice += dp;
                    mfgRetailPrice += rp;
                }
            }
            TotalMSRPDealerPriceEX = mfgDealerPrice + TotalMFGMSRPDealerPrice + MSRPDealerPrice; 
            TotalMSRPRetailPriceEX = mfgRetailPrice + TotalMFGMSRPRetailPrice + MSRPRetailPrice;
            
        }
        console.log('>>>>>>>>>>>>>>>mfgDealerPrice: '+mfgDealerPrice);
        component.set("v.DlrOptionDealerPrice", parseFloat(mfgDealerPrice).toFixed(2));
        component.set("v.DlrOptionRetailPrice", parseFloat(mfgRetailPrice).toFixed(2));
        component.set('v.TotalMSRPDealerPrice', parseFloat(TotalMSRPDealerPriceEX).toFixed(2));
        component.set('v.TotalMSRPRetailPrice', parseFloat(TotalMSRPRetailPriceEX).toFixed(2));
        if(TotalMSRPRetailPriceEX != undefined) {
            if(component.get("v.PrntAtt") == 'Inventory') {
                var cmpEvent = $A.get("e.c:InvMSRPEvent");
                cmpEvent.setParams({ 
                    "msrp": TotalMSRPRetailPriceEX
                }); 
                cmpEvent.fire();
            }
        }
        if(TotalMSRPDealerPriceEX != undefined) {
            if(component.get("v.PrntAtt") == 'Inventory') {
                var cmpEvent = $A.get("e.c:InvDealerPriceEvent");
                cmpEvent.setParams({ 
                    "msrp": TotalMSRPDealerPriceEX
                });
                cmpEvent.fire();
            } 
        }
        
        
        
        
    },
    handelBlank: function(component, event, helper) {
        console.log('Blank');
        component.set('v.ProductDealerPrice', 0.00); 
        component.set('v.ProductRetailPrice', 0.00);
        component.set("v.MfgOptionDealerPrice", 0.00);
        component.set("v.MfgOptionRetailPrice", 0.00);
        component.set("v.DlrOptionDealerPrice", 0.00);
        component.set("v.DlrOptionRetailPrice", 0.00);
        component.set('v.TotalMSRPDealerPrice', 0.00);
        component.set('v.TotalMSRPRetailPrice', 0.00);
    }
})