({
    doInit : function(component, event, helper) {
        helper.getAllEvents(component, event, helper);
    },
    saveCustomerComment : function(component, event, helper){
        helper.showSpinner(component, event, helper);
        var action = component.get("c.addCustomerComment");
        console.log('typeeeeeeeee',component.get("v.Type"));
        console.log('component.get("v.commentSectionName")',component.get("v.commentSectionName"));
        action.setParams({
            "subject" : component.get("v.commentSubject"),
            "customerComment" : component.get("v.customerComment"),
            "whatId" : component.get("v.whatId"),
            "whoId" : component.get("v.whoId"),
            "accountId" : component.get("v.accountId"),
            "sectionName" : component.get("v.commentSectionName"),
            "Type" : component.get("v.Type")
        });
        //console.log('component.get("v.whatId")',component.get("v.whatId"));
        action.setCallback(this, function(response){
            var state = response.getState();
            helper.hideSpinner(component, event, helper);
            if(state === "SUCCESS"){
              
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The comment has been added successfully.",
                    "type":"success"
                });
                toastEvent.fire();  
                component.set("v.commentSubject",'');
                component.set("v.customerComment",'');
                helper.getAllEvents(component, event, helper); 
            }
        });

        $A.enqueueAction(action);

    }
})