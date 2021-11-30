({
      doinit : function(component, event, helper) {
          
          var action = component.get('c.getWOfromDelarshipForm'); 
          action.setParams({
              "recId" : component.get('v.recordId') 
          });
          
          
          
          action.setCallback(this, function(a){
              var state = a.getState(); // get the response state
              if(state == 'SUCCESS') {
                  var result = a.getReturnValue();
               //   alert(result.BOATBUILDING__Work_Order__c);
                  if(result.BOATBUILDING__Work_Order__c != null && result.BOATBUILDING__Work_Order__c != ''){
                      var urlEvent = $A.get("e.force:navigateToURL");
                      var urlStr = "/apex/BOATBUILDING__ServiceInspectionForm?woId="+result.BOATBUILDING__Work_Order__c;
                      urlEvent.setParams({
                          "url": urlStr
                      });
                      urlEvent.fire();
                      $A.get("e.force:closeQuickAction").fire();
                  }else{
                      var toastEvent = $A.get("e.force:showToast");
                      toastEvent.setParams({
                          "title": "Error",
                           "type": 'error',
                          "message": "Please select work order"
                      });
                      toastEvent.fire();
                      var dismissActionPanel = $A.get("e.force:closeQuickAction");
                      dismissActionPanel.fire();
                  }
                  
              }
          });
          $A.enqueueAction(action);
          
          
          
          
          
            }
        })