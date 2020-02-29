({
    Submit : function(component, event, helper) {
        console.log("Method Called")
        var objACV= component.get("v.objACV1");
        
        if($A.util.isEmpty(objACV.Name) 
           || $A.util.isUndefined(objACV.Name)) {
            
            alert('ACV Form Name is Required');
            return;
        }     
        
        if($A.util.isEmpty(objACV.BOATBUILDING__High_Comp_1_Amount__c) 
           || $A.util.isUndefined(objACV.BOATBUILDING__High_Comp_1_Amount__c)) {
            
            alert('High Comp 1 Amount is Rqquired');
            return;
        }
        if($A.util.isEmpty(objACV.BOATBUILDING__Low_Comp_1_Amount__c) 
           || $A.util.isUndefined(objACV.BOATBUILDING__Low_Comp_1_Amount__c)) {
            
            alert('Low Comp 1 Amount is Required');
            return;
        }
        
        if($A.util.isEmpty(objACV.BOATBUILDING__High_Comp_2_Amount__c) 
           || $A.util.isUndefined(objACV.BOATBUILDING__High_Comp_2_Amount__c)) {
            
            alert('High Comp 2 Amount is Rqquired');
            return;
        }
        if($A.util.isEmpty(objACV.BOATBUILDING__Low_Comp_2_Amount__c) 
           || $A.util.isUndefined(objACV.BOATBUILDING__Low_Comp_2_Amount__c)) {
            
            alert('Low Comp 2 Amount is Required');
            return;
        }
        
        if($A.util.isEmpty(objACV.BOATBUILDING__High_Comp_3_Amount__c) 
           || $A.util.isUndefined(objACV.BOATBUILDING__High_Comp_3_Amount__c)) {
            
            alert('High Comp 3 Amount is Rqquired');
            return;
        }
        if($A.util.isEmpty(objACV.BOATBUILDING__Low_Comp_3_Amount__c) 
           || $A.util.isUndefined(objACV.BOATBUILDING__Low_Comp_3_Amount__c)) {
            
            alert('Low Comp 3 Amount is Required');
            return;
        }		
        
        var action= component.get("c.saveACVForm");
        action.setParams({
            "objACV": objACV 
        });
        console.log(objACV);
        console.log(objACV);
        action.setCallback(this,function(response) {
            var state= response.getState(); 
            if (state === "SUCCESS") {
                console.log(response.getReturnValue().Id);
                component.set("v.objACV1", response.getReturnValue());
                component.set("v.selectedLookUpRecordACVCC", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({ 
                    "title": "Success!",
                    "message": "The ACV has been created and sent for approval. Please wait untill record gets approved.",
                    "duration":"5000",
                    "key": 'info_alt',
                    "type": 'success',
                    "mode": 'dismissible'
                });
                toastEvent.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})