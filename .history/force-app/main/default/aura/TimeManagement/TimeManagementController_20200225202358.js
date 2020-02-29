({
    init : function(component, event, helper) {
        //var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var today = new Date();
        component.set('v.today', today);
        var action = component.get("c.getTimeManagement");
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                console.log('>>>>',response.getReturnValue());
                component.set("v.objTimeM", response.getReturnValue());
                helper.changeButtonStatus(component, event, helper);
            }
        });
         $A.enqueueAction(action);

    }, 
    dayIn : function(component, event, helper){

    },
    dayOut : function(component, event, helper){
        
    },
    lunchIn : function(component, event, helper){
        
    },
    lunnchOut : function(component, event, helper){
        
    }
})