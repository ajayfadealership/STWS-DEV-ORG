({
	changePPDOOption : function(component, event, helper) {
		var objDO = component.get("v.objDO");
        var lstDO = component.get("v.newPLstDealerOptionWraperC");
        console.log(component.get("v.objDOCheck")); 
        var checkStatus = '0'; 
        var DealerOptionIdListCCCC = component.get("v.DealerOptionIdListCCCC");
        if(component.find("ppdocheck").get("v.value")) {
            checkStatus = '1'; 
        }
        
        if(checkStatus == '1') {
            DealerOptionIdListCCCC.push(objDO.objDealerOption.BOATBUILDING__Part_Number__c); 
        } else { 
            DealerOptionIdListCCCC.splice(DealerOptionIdListCCCC.indexOf(objDO.objDealerOption.BOATBUILDING__Part_Number__c), 1);
        }
        
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