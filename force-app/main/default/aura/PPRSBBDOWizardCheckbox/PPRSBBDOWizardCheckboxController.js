({
	changePPDOOption : function(component, event, helper) {
		var objDO = component.get("v.objDO");
        var lstDO = component.get("v.newPLstDealerOptionWraperC");
        var DealerOptionIdListQTCCCC = component.get("v.DealerOptionIdListQTCCCC");
        console.log(component.get("v.objDOCheck")); 
        var checkStatus = '0'; 
        var DealerOptionIdListCCCC = component.get("v.DealerOptionIdListCCCC");
        if(component.find("ppdocheck").get("v.value")) {
            checkStatus = '1'; 
        }
        var QT = objDO.objDealerOption.BOATBUILDING__Quantity__c != undefined && objDO.objDealerOption.BOATBUILDING__Quantity__c != '' ? objDO.objDealerOption.BOATBUILDING__Quantity__c : 1;
        if(checkStatus == '1') {
            DealerOptionIdListCCCC.push(objDO.objDealerOption.BOATBUILDING__Part_Number__c); 
            DealerOptionIdListQTCCCC.push(objDO.objDealerOption.BOATBUILDING__Part_Number__c + ':'+ QT);
        } else { 
            DealerOptionIdListCCCC.splice(DealerOptionIdListCCCC.indexOf(objDO.objDealerOption.BOATBUILDING__Part_Number__c), 1);
            DealerOptionIdListQTCCCC.splice(DealerOptionIdListQTCCCC.indexOf(objDO.objDealerOption.BOATBUILDING__Part_Number__c + ':'+ QT), 1);
        }
        console.log('DealerOptionIdListQTCCCC check: ',DealerOptionIdListQTCCCC);
        component.set("v.DealerOptionIdListQTCCCC", DealerOptionIdListQTCCCC);
        component.set("v.DealerOptionIdListCCCC", DealerOptionIdListCCCC);
        component.set("v.newPLstDealerOptionWraperC", lstDO);
        
        var cmpEvent = $A.get("e.c:PPDOIdEvent");
        
        cmpEvent.setParams({ 
            "objDOId": objDO.objDealerOption.BOATBUILDING__Part_Number__c,
            "PPStatus": checkStatus, 
            "DOList" : DealerOptionIdListCCCC,
            "DealerOptionWraper" : lstDO
        }); 
        cmpEvent.fire();
	},
    doInit: function(component, event, helper) {
    	var checkStatus = '0';
        var objDO = component.get("v.objDO");
        var DealerOptionIdListCCCC = component.get("v.DealerOptionIdListCCCC");
        var lstDO = component.get("v.newPLstDealerOptionWraperC");
        if(component.get("v.objDOCheck")) {
            checkStatus = '1'; 
        } 
        if(checkStatus == '1') {
            DealerOptionIdListCCCC.push(objDO.objDealerOption.BOATBUILDING__Part_Number__c); 
            
            var DealerOptionIdListQTCCCC = component.get("v.DealerOptionIdListQTCCCC");
            var QT = objDO.objDealerOption.BOATBUILDING__Quantity__c != undefined && objDO.objDealerOption.BOATBUILDING__Quantity__c != '' ? objDO.objDealerOption.BOATBUILDING__Quantity__c : 1;
            var strPPId = objDO.objDealerOption.BOATBUILDING__Part_Number__c;
            if(!DealerOptionIdListQTCCCC.includes(objDO.objDealerOption.BOATBUILDING__Part_Number__c + ':'+ QT)) {
                DealerOptionIdListQTCCCC.push(objDO.objDealerOption.BOATBUILDING__Part_Number__c + ':'+ QT);
            }
            component.set("v.DealerOptionIdListQTCCCC", DealerOptionIdListQTCCCC);
            console.log('DealerOptionIdListQTCCCC doinit: ',DealerOptionIdListQTCCCC);
            var cmpEvent = $A.get("e.c:PPDOIdEvent");
            console.log('>>True Status: '+lstDO);
            console.log('>>DealerOptionIdListCCCC: '+DealerOptionIdListCCCC);
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