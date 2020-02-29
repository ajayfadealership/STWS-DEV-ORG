({  doInit : function(component, event, helper){
    var urlHasParam = component.get("v.pageReference").state.redirect;
    window.onbeforeunload = function (evt) {
        console.log('hello');
        var message = '!! Leaving this page may cause loss of data !!\n';
        if (typeof evt == 'undefined') evt = window.event;
        if (evt) evt.returnValue = message;
        return message; 
        
    } 
    
},
  handleClick : function(component, event, helper) {
      var ctarget = event.currentTarget;
      var id_str = parseInt(ctarget.dataset.value);
      // 
      var objAcc = component.get("v.selectedLookUpRecordAcc");
      
      if(id_str == 1) {
          if(objAcc != null && objAcc != undefined && objAcc.Id != null && objAcc.Id != undefined) {
              var urlEvent = $A.get("e.force:navigateToURL");
              window.onbeforeunload = null;
              urlEvent.setParams({
                  "url": '/'+objAcc.Id
              });
              urlEvent.fire();
              $A.get("e.force:closeQuickAction").fire();
          } else {
              helper.callNext(component, event, ctarget.dataset);
          }
      } else {
          helper.callNext(component, event, ctarget.dataset);
      }
  },
  previousClick : function(component, event, helper) {
      console.log('run');
      var ctarget = event.currentTarget;
      var id_str = parseInt(ctarget.dataset.value);
      console.log(id_str); 
      
      var prevInd = id_str - 1;
      
      
      var prevLI = prevInd+"LI";
      var currLI = id_str+"LI";
      
      
      var CurrId = "tab-default-"+id_str;
      var PrevId = "tab-default-"+prevInd;
      
      var currElement = document.getElementById(CurrId);
      var prevElement = document.getElementById(PrevId);
      $A.util.toggleClass(prevElement, "slds-show");
      $A.util.toggleClass(prevElement, "slds-hide");
      $A.util.toggleClass(currElement, "slds-show");
      $A.util.toggleClass(currElement, "slds-hide");
      console.log('asdfadsfasdf');
      var currLIel = document.getElementById(currLI);
      var prevLIel = document.getElementById(prevLI);
      $A.util.removeClass(currLIel, "slds-is-current");
      $A.util.removeClass(currLIel, "slds-is-active");
      $A.util.addClass(currLIel, "slds-is-incomplete");
      $A.util.removeClass(prevLIel, "slds-is-complete");
      $A.util.addClass(prevLIel, "slds-is-active");
      $A.util.addClass(prevLIel, "slds-is-current"); 
      
  },
  HandelAccountEvent: function(component, event, helper) {
      var objAcc = event.getParam("objAccount");
      var tab = event.getParam("tab");
      var objAccEx = component.get("v.objAccount");
      if(tab == "two") {
          console.log("two")
          objAccEx.Name = objAcc.Name;
          objAccEx.BOATBUILDING__Prospect_Last_Name__c = objAcc.BOATBUILDING__Prospect_Last_Name__c;
          objAccEx.BOATBUILDING__Prospect_First_Name__c = objAcc.BOATBUILDING__Prospect_First_Name__c;
          objAccEx.BOATBUILDING__Contact_First_Name__c = objAcc.BOATBUILDING__Contact_First_Name__c;
          objAccEx.BOATBUILDING__Contact_Last_Name__c = objAcc.BOATBUILDING__Contact_Last_Name__c;
          objAccEx.BOATBUILDING__Account_Customer_Type__c = objAcc.BOATBUILDING__Account_Customer_Type__c;
          objAccEx.BOATBUILDING__Sub_Account_Type__c = objAcc.BOATBUILDING__Sub_Account_Type__c;
          objAccEx.Phone = objAcc.Phone;
          objAccEx.BOATBUILDING__Prospect_Mobile_Phone_Number__c = objAcc.BOATBUILDING__Prospect_Mobile_Phone_Number__c;
          objAccEx.BOATBUILDING__Email__c = objAcc.BOATBUILDING__Email__c;
          objAccEx.BOATBUILDING__Communication_Type_With_Customer__c = objAcc.BOATBUILDING__Communication_Type_With_Customer__c;
          objAccEx.BOATBUILDING__Lead_Source__c = objAcc.BOATBUILDING__Lead_Source__c;
          objAccEx.BOATBUILDING__Lead_Status__c = objAcc.BOATBUILDING__Lead_Status__c;
          objAccEx.BOATBUILDING__Comments__c = objAcc.BOATBUILDING__Comments__c;
          objAccEx.BOATBUILDING__Account_Balance__c = objAcc.BOATBUILDING__Account_Balance__c;
          objAccEx.BOATBUILDING__Store_Location__c = objAcc.BOATBUILDING__Store_Location__c;
          objAccEx.BillingStreet = objAcc.BillingStreet;
          objAccEx.BillingCity = objAcc.BillingCity;
          objAccEx.BillingState = objAcc.BillingState;
          objAccEx.BillingPostalCode = objAcc.BillingPostalCode;
      } else if(tab == "three") {
          console.log("three")
          objAccEx.BOATBUILDING__Desired_Boat_Manufacturer__c = objAcc.BOATBUILDING__Desired_Boat_Manufacturer__c;
          objAccEx.BOATBUILDING__Desire_boat_model__c = objAcc.BOATBUILDING__Desire_boat_model__c;
          objAccEx.BOATBUILDING__Prospect_Desired_Boat_Length__c = objAcc.BOATBUILDING__Prospect_Desired_Boat_Length__c;
          objAccEx.BOATBUILDING__Desire_price_high__c = objAcc.BOATBUILDING__Desire_price_high__c;
          objAccEx.BOATBUILDING__Desire_Price_low__c = objAcc.BOATBUILDING__Desire_Price_low__c;
          objAccEx.BOATBUILDING__Desired_PaymentBB__c = objAcc.BOATBUILDING__Desired_PaymentBB__c;
          objAccEx.BOATBUILDING__Customer_Also_Shopping_Brand_A__c = objAcc.BOATBUILDING__Customer_Also_Shopping_Brand_A__c;
          objAccEx.BOATBUILDING__Customer_Also_Shopping_Brand_B__c = objAcc.BOATBUILDING__Customer_Also_Shopping_Brand_B__c;
      } else if(tab == "four") {
          console.log("four")
          objAccEx.BOATBUILDING__Customer_Trade_in_Date__c = objAcc.BOATBUILDING__Customer_Trade_in_Date__c;
          objAccEx.BOATBUILDING__Prospect_Purchase_Date_of_Current_Boat__c = objAcc.BOATBUILDING__Prospect_Purchase_Date_of_Current_Boat__c;
          objAccEx.BOATBUILDING__Trade_Make__c = objAcc.BOATBUILDING__Trade_Make__c;
          objAccEx.BOATBUILDING__Trade_Model__c = objAcc.BOATBUILDING__Trade_Model__c;
          objAccEx.BOATBUILDING__Trade_Model_Year__c = objAcc.BOATBUILDING__Trade_Model_Year__c;
          objAccEx.BOATBUILDING__Trade_Boat_Hrs__c = objAcc.BOATBUILDING__Trade_Boat_Hrs__c;
          objAccEx.BOATBUILDING__Trade_Pay_Off__c = objAcc.BOATBUILDING__Trade_Pay_Off__c;
          objAccEx.BOATBUILDING__Trade_Lien_Bank__c = objAcc.BOATBUILDING__Trade_Lien_Bank__c;
          objAccEx.BOATBUILDING__Prospect_HIN_of_Current_Boat__c = objAcc.BOATBUILDING__Prospect_HIN_of_Current_Boat__c;
          objAccEx.BOATBUILDING__Trade_Boat_Engine_SN__c = objAcc.BOATBUILDING__Trade_Boat_Engine_SN__c;
          objAccEx.BOATBUILDING__Trade_Boat_Trailer_VIN__c = objAcc.BOATBUILDING__Trade_Boat_Trailer_VIN__c;
      } else if(tab == "five") {
          console.log("five")
          objAccEx.BOATBUILDING__Probability_of_Closing__c = objAcc.BOATBUILDING__Probability_of_Closing__c;
          objAccEx.BOATBUILDING__Pro__c = objAcc.BOATBUILDING__Pro__c;
          objAccEx.BOATBUILDING__Probability_of_Revenue_Amount__c = objAcc.BOATBUILDING__Probability_of_Revenue_Amount__c;
          objAccEx.BOATBUILDING__Customer_Obsticle_1__c = objAcc.BOATBUILDING__Customer_Obsticle_1__c;
          objAccEx.BOATBUILDING__Customer_Obstacle_2__c = objAcc.BOATBUILDING__Customer_Obstacle_2__c;
          var action = component.get("c.createAccountApex");
          action.setParams({
              "objAccount": objAccEx
          });
          action.setCallback(this, function(res) {
              if(res.getState() == "SUCCESS") {
                  console.log(res.getReturnValue());
                  var urlEvent = $A.get("e.force:navigateToURL");
                  window.onbeforeunload = null;
                  $A.get('e.force:refreshView').fire();
                  urlEvent.setParams({
                      "url": '/'+res.getReturnValue()
                  });
                  urlEvent.fire();
                  $A.get("e.force:closeQuickAction").fire();
              }
          });
          $A.enqueueAction(action);
      } 
  }
 })