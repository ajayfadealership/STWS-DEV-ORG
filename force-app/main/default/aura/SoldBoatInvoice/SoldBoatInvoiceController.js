({
    init : function(component, event, helper) {
        var action = component.get("c.getdirectToForLighting");
        action.setParams({
            "recId" :  component.get("v.recordId")
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
              if (result.includes("Error")){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    title : 'Error',
                    message: result,
                    type: 'error',
                    mode: 'sticky',
                }); 
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();


              }else{
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": result,
                  "slideDevName": "Detail"
                });
                navEvt.fire();
            }
               
            }
            else{
                console.log('response.getError()',response.getError());
                var errorMsg = response.getError()[0].message;
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    title : 'Error',
                    message: errorMsg,
                    type: 'error',
                    mode: 'sticky',
                }); 
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
               
            }
    
        });
    
        $A.enqueueAction(action); 
        
    }
})