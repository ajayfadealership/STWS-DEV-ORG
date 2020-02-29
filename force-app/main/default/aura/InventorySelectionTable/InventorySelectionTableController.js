({
	getProductPriceFromInv : function(component, event, helper) {
		var InvId = component.get('v.objInvW').objInv.Id;
        //alert(InvId);
        //InvIdCC
        //qtSpinnerWiz
        document.getElementById("qtSpinnerWiz").style.display = 'block';
        component.set('v.InvIdCC', InvId)
        var action = component.get("c.getProductPriceApex");
        action.setParams({
            "invId" : InvId
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            document.getElementById("qtSpinnerWiz").style.display = 'none';
            if(state == 'SUCCESS') {
                document.getElementById("toglSectionForNewORExProduct").style.display = "none";
                document.getElementById("PPSectionBBWizard").style.display = "block";
                document.getElementById("ExistigInvList").style.display = "none";
                document.getElementById("newInvCreate").style.display = "none";
                //console.log(res.getReturnValue());
                var cmpEvent = $A.get("e.c:ProductPriceEvent"); 
                
                cmpEvent.setParams({
                    "lstPriceAndProductOptionWraperClassPPE": res.getReturnValue()
                });
                cmpEvent.fire();  
                
                var action1 = component.get("c.getDealerPriceApex1"); 
                action1.setParams({
                    "invId" : InvId
                });
                action1.setCallback(this, function(res1) {
                    var state = res1.getState();
                    console.log(res1.getReturnValue());
                    if(state == 'SUCCESS') {
                        component.set('v.lstDealerOptionWraperCC', res1.getReturnValue());
                        var doLst = component.get('v.lstDealerOptionWraperCC');
                        var cmpEvent = $A.get("e.c:DealerOptionEvent");
                        
                        cmpEvent.setParams({
                            "newPLstDealerOptionWraper": doLst
                        });
                        cmpEvent.fire(); 
                        
                    }  
                }) 
                $A.enqueueAction(action1);
                
            }  
        }); 
        $A.enqueueAction(action);
        
        
        if(InvId != undefined) {
            var action2 = component.get("c.getProdutPriceingApexMD");
            action2.setParams({
                "invId" : InvId
            });
            action2.setCallback(this, function(res) {
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
            $A.enqueueAction(action2);
        }
	}
})