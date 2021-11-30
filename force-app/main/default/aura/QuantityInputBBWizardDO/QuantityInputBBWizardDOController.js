({
    updateTotal : function(component, event, helper) {
        var checkStatus = '0';
        var objDO = component.get("v.objDO");
        var DealerOptionIdListCCCC = component.get("v.DealerOptionIdListCCCC");
        var DealerOptionIdListQTCCCC = component.get("v.DealerOptionIdListQTCCCC");
        var lstDO = component.get("v.newPLstDealerOptionWraperC");
        if(component.get("v.objDOCheck")) {
            checkStatus = '1'; 
        } 
        if(checkStatus == '1') {
            //DealerOptionIdListCCCC.push(objDO.objDealerOption.BOATBUILDING__Part_Number__c); 
            var cmpEvent = $A.get("e.c:PPDOIdEvent");
            console.log('>>True Status: '+lstDO);
            console.log('>>DealerOptionIdListCCCC: '+DealerOptionIdListCCCC);
            var strPPId = objDO.objDealerOption.BOATBUILDING__Part_Number__c;
            var QT = objDO.objDealerOption.BOATBUILDING__Quantity__c != undefined && objDO.objDealerOption.BOATBUILDING__Quantity__c != '' ? objDO.objDealerOption.BOATBUILDING__Quantity__c : 1;
            if(DealerOptionIdListQTCCCC.length > 0) {
                for(var i = 0; i < DealerOptionIdListQTCCCC.length; i++) {
                    if(DealerOptionIdListQTCCCC[i].includes(strPPId)) {
                        console.log('DealerOptionIdListQTCCCC[i] QT: '+DealerOptionIdListQTCCCC[i]);
                        DealerOptionIdListQTCCCC.splice(i, 1);
                        DealerOptionIdListQTCCCC.push(strPPId + ':' + QT);
                    }
                }
            }
            component.set("v.DealerOptionIdListQTCCCC", DealerOptionIdListQTCCCC);
            console.log('DealerOptionIdListQTCCCC: ',DealerOptionIdListQTCCCC);
            cmpEvent.setParams({ 
                "objDOId": objDO.objDealerOption.BOATBUILDING__Part_Number__c,
                "PPStatus": checkStatus,
                "DOList" : DealerOptionIdListCCCC,
                "DealerOptionWraper" : lstDO 
            });
            cmpEvent.fire();
        }
    }
})