({
    getAllEvents : function(component, event, helper) {
        this.showSpinner(component, event, helper);
        var commentSectionName = component.get("v.commentSectionName");
        
        var action = component.get("c.getAllEventsForJob");
        var eventType = [];
        if(commentSectionName == "Customer Comment"){
            eventType.push('Customer Comment');
            eventType.push('Comment for Customer');
        }
        if(commentSectionName == "Service Writer Comment" || commentSectionName == "Tech Comment"){
            eventType.push('Comment from Technician');
            eventType.push('Comment for Technician');
        }

        if(commentSectionName == "Work order Section"){
            eventType.push('All');
        }
      
        action.setParams({
            "woId" : component.get("v.whatId"),
            "setCommentTypes" : eventType
        });
        action.setCallback(this, function(response){
            this.hideSpinner(component, event, helper);
            //console.log('allevent',response.getReturnValue());
            component.set("v.allEvents",response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    showSpinner : function(component,event,helper){
        // display spinner when aura:waiting (server waiting)
          component.set("v.toggleSpinner", true);  
        },
      hideSpinner : function(component,event,helper){
     // hide when aura:downwaiting
          component.set("v.toggleSpinner", false);
          
      }
})