({
    hideDOPopup: function(component, event, helper) {
        document.getElementById("doId").style.display = 'none';
    },
    addDealerOptionToList: function(component, event, helper) {
        var DOName = document.getElementById("decIdBB").value;
        var DODlrPName = document.getElementById("delIdBB").value;
        var DORtlPName = document.getElementById("retIdBB").value;
        var QT = document.getElementById("qtIdBB").value;
        var DealerOptionIdListCCCC = component.get("v.DealerOptionIdListCCCC");
        var DealerOptionIdListQTCCCC = component.get("v.DealerOptionIdListQTCCCC");
        console.log('>>>DOName: '+DOName);
        console.log('>>>DODlrPName: '+DODlrPName);
        console.log('>>>DORtlPName: '+DORtlPName);
        console.log('>>>DealerOptionIdListCCCC: '+DealerOptionIdListCCCC);
        var prtNo = Math.floor(Math.random()*100000);
        var taxableCheck = '0';
        if(document.getElementById("ntCheck").checked) {
            taxableCheck = '1';
        }
        
        var lstDO = component.get("v.newPLstDealerOptionWraperND");
        
        if(DOName != null && DODlrPName != null && DORtlPName != null) {
            var action = component.get("c.updateDealerOptionApex");
            console.log('>>>action: '+action);
            action.setParams({
                "strName": DOName,
                "strDealerPrice": DODlrPName,
                "strRetailPrice": DORtlPName,
                "strPrtName": prtNo.toString(),
                "taxCheck": taxableCheck,
                "strqt" : QT
            });
            action.setCallback(this, function(res) {
                var state = res.getState();
                console.log(res.getReturnValue());
                if(state == 'SUCCESS') {
                    document.getElementById("decIdBB").value = '';
                    document.getElementById("delIdBB").value = '';
                    document.getElementById("retIdBB").value = '';
                    document.getElementById("ntCheck").checked = false;
                    console.log(lstDO);
                    lstDO.push(res.getReturnValue());
                    console.log(lstDO);

                    var cmpEvent = $A.get("e.c:PPDOIdEvent");
                    var checkStatus = '1';
                    if(checkStatus == '1') {
                        console.log(res.getReturnValue().objDealerOption.BOATBUILDING__Part_Number__c);
                        DealerOptionIdListCCCC.push(res.getReturnValue().objDealerOption.BOATBUILDING__Part_Number__c);  
                        DealerOptionIdListQTCCCC.push(res.getReturnValue().objDealerOption.BOATBUILDING__Part_Number__c+':'+QT);  
                    } 
                    
                    component.set("v.DealerOptionIdListCCCC", DealerOptionIdListCCCC);
                    component.set("v.DealerOptionIdListQTCCCC", DealerOptionIdListQTCCCC);
                    component.set("v.newPLstDealerOptionWraperND", lstDO);
                    
                    console.log(JSON.stringify(component.get('v.lstDO')));
                    if(cmpEvent != undefined) {
                        cmpEvent.setParams({ 
                            "objDOId": res.getReturnValue().objDealerOption.BOATBUILDING__Part_Number__c,
                            "PPStatus": checkStatus,
                            "DOList" : DealerOptionIdListCCCC,
                            "DealerOptionWraper" : lstDO
                        });
                        cmpEvent.fire();
                    }
                    
                    if($A.get("e.c:DealerOptionEvent") != undefined) {
                        var cmpEvent = $A.get("e.c:DealerOptionEvent");
                        cmpEvent.setParams({
                            "newPLstDealerOptionWraper": lstDO
                        }); 
                        cmpEvent.fire(); 
                    }
                    component.set("v.doBool", false);
                    document.getElementById("doId").style.display = 'none';

                }  
            })
            $A.enqueueAction(action);
        } else {
            alert("Please enter all options."); 
        }
    } 
})