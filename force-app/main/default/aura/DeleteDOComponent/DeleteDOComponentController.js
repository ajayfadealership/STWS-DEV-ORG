({
    RemoveItem : function(component, event, helper) {
        var objDO = component.get("v.objDO");
        var lstDO = component.get("v.newPLstDealerOptionWraperDLT");
        var lstDOBlank = component.get("v.newPLstDealerOptionWraperBlank");
        var DealerOptionIdListCCCC = component.get("v.DealerOptionIdListCCCC");        
        
        
        for(var i = 0; i < lstDO.length; i++) {
            if(lstDO[i].objDealerOption.BOATBUILDING__Part_Number__c != objDO.BOATBUILDING__Part_Number__c) {
                lstDOBlank.push(lstDO[i]);
            }
        }
        var cmpEvent = $A.get("e.c:PPDOIdEvent");
        var checkStatus = '0';
        
        if(checkStatus == '0') { 
            DealerOptionIdListCCCC.splice(DealerOptionIdListCCCC.indexOf(objDO.BOATBUILDING__Part_Number__c), 1);
        }
        
        component.set("v.DealerOptionIdListCCCC", DealerOptionIdListCCCC);
        
        component.set("v.newPLstDealerOptionWraperDLT", lstDOBlank);
        
        cmpEvent.setParams({ 
            "objDOId": objDO.BOATBUILDING__Part_Number__c,
            "PPStatus": checkStatus,
            "DOList" : DealerOptionIdListCCCC,
            "DealerOptionWraper" : lstDOBlank
        });
        cmpEvent.fire(); 
        
        var cmpEvent2 = $A.get("e.c:DealerOptionEvent");
        cmpEvent2.setParams({
            "newPLstDealerOptionWraper": lstDOBlank 
        });
        cmpEvent2.fire();  
    }
})