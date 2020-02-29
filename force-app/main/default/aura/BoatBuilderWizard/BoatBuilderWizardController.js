({  doInit : function(component, event, helper){
    //console.log(component.get("v.pageReference").state.redirect);
    var urlHasParam = component.get("v.pageReference").state.redirect;
    
    if(urlHasParam == "frombbwiz") 
    { 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The Account has been created. Please use the search bar to select the new customer.",
            "duration":"5000",
            "key": 'info_alt',
            "type": 'success',
            "mode": 'dismissible'
        });
        toastEvent.fire();
    }
    window.onbeforeunload = function (evt) {
        if(component.get("v.fromBBNav") == 'true')
        {
            console.log('hi');
        }
        else
        {
            console.log('hello');
            var message = '!! Leaving this page may cause loss of data !!\n';
            if (typeof evt == 'undefined') evt = window.event;
            if (evt) evt.returnValue = message;
            return message; 
        }
    } 
    
    var action = component.get("c.isNoSalesmanWithoutCost");
    action.setCallback(this, function(res) {
        var state = res.getState();
        console.log(res.getReturnValue());
        if(state == 'SUCCESS') {
            component.set("v.NoSalesmanWithoutCost", res.getReturnValue());
        }
    });  
    
    $A.enqueueAction(action);
    
    
},
  handleClick : function(component, event, helper) {
      
      var ctarget = event.currentTarget;
      var id_str = parseInt(ctarget.dataset.value);
      console.log(id_str); 
      if(id_str == 1) {
          var objAcc = component.get("v.selectedLookUpRecordvalueAcc");
          if(objAcc != null && objAcc != undefined && objAcc.Id != null && objAcc.Id != undefined) {
              helper.callNext(component, event, ctarget.dataset);        
          } else {
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                  "title": "Error!",
                  "message": "Please Select Customer Or Create New.",
                  "duration":"5000",
                  "key": 'info_alt',
                  "type": 'error',
                  "mode": 'dismissible'
              });
              toastEvent.fire();
          }
      } 
      else if(id_str == 2) {
          var invId = component.get("v.InvId");
          var proId = component.get("v.ProId");
          if(invId != '0' || proId != '0') {
              console.log(invId);
              console.log(proId);
              console.log('Main: '); 
              console.log(component.get("v.ProductPriceIdList"));
              console.log(component.get("v.DealerOptionIdList"));
              helper.callNext(component, event, ctarget.dataset);        
          } else {
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                  "title": "Error!",
                  "message": "Please Select Inventory First.",
                  "duration":"5000",
                  "key": 'info_alt',
                  "type": 'error',
                  "mode": 'dismissible'
              });
              toastEvent.fire();
          }
      }
          else if(id_str == 3) {
              var objAcv = component.get("v.selectedLookUpRecordACVP");
              if(objAcv != null && objAcv != undefined && objAcv.Id != null && objAcv.Id != undefined) {
                  var action = component.get("c.getApprovalCheck");
                  action.setParams({
                      "AcvId": objAcv.Id
                  });
                  action.setCallback(this, function(res) {
                      var state = res.getState();
                      console.log(res.getReturnValue());
                      if(state == 'SUCCESS') {
                          if(res.getReturnValue() == '1') {
                              helper.callNext(component, event, ctarget.dataset);        
                          } else {
                              var toastEvent = $A.get("e.force:showToast");
                              toastEvent.setParams({
                                  "title": "Error!",
                                  "message": "ACV Form is not Approved.",
                                  "duration":"5000",
                                  "key": 'info_alt',
                                  "type": 'error',
                                  "mode": 'dismissible'
                              });
                              toastEvent.fire();
                          }
                      }  
                  })
                  $A.enqueueAction(action);
                  
              } else {
                  objAcv.Id = '0';
                  helper.callNext(component, event, ctarget.dataset);  
              }
          } 
              else if(id_str == 4) {
                  document.getElementById("qtSpinnerWiz").style.display = 'block';
                  var varAcc = component.get("v.selectedLookUpRecordvalueAcc");
                  var varInvId = component.get("v.InvId");
                  var varProId = component.get("v.ProId");
                  var varselectedLookUpRecordACVP = component.get("v.selectedLookUpRecordACVP");
                  var varCustomSettingSobjRegFeeP = component.get("v.customSettingSobjRegFeeP");
                  var lstProductPriceIdList = component.get("v.ProductPriceIdList");
                  var lstDealerOptionIdList = component.get("v.DealerOptionIdList");
                  var objQTRR = component.get("v.ObjQuoteRR");
                  var state = '';
                  var MaualTax = '0.00';
                  if(objQTRR.BOATBUILDING__State__c != undefined) {
                      state = objQTRR.BOATBUILDING__State__c;
                  }
                  if(objQTRR.BOATBUILDING__Manual_Sales_Tax_Entry__c  != undefined) {
                      MaualTax = objQTRR.BOATBUILDING__Manual_Sales_Tax_Entry__c ;
                  }
                  var DealerOptionList = component.get("v.lstDealerOptionWraper");
                  console.log(varAcc.Id);
                  console.log(varInvId);
                  console.log(varProId);
                  console.log(varselectedLookUpRecordACVP.Id);
                  console.log(varCustomSettingSobjRegFeeP.BOATBUILDING__Doc_Fee__c);
                  console.log(varCustomSettingSobjRegFeeP.BOATBUILDING__Registration_Fee__c);
                  console.log(varCustomSettingSobjRegFeeP.BOATBUILDING__Trailer_Registration_Fee__c);
                  console.log(state); 
                  console.log(MaualTax); 
                  console.log(DealerOptionList); 
                  
                  if(state == undefined || state == null || state == '') {
                      var toastEvent = $A.get("e.force:showToast");
                      toastEvent.setParams({
                          "title": "Warning!",
                          "message": "Please select the state.",
                          "duration":"5000",
                          "key": 'info_alt',
                          "type": 'Warning',
                          "mode": 'dismissible'
                      });
                      toastEvent.fire();
                      document.getElementById("qtSpinnerWiz").style.display = 'none';
                      return;
                  }
                  
                  var action = component.get("c.generateQuote");
                  action.setParams({
                      "strAccountId": varAcc.Id,
                      "strInvId": varInvId,
                      "ProId": varProId,
                      "ACVId": varselectedLookUpRecordACVP.Id,
                      "regFee": String(varCustomSettingSobjRegFeeP.BOATBUILDING__Registration_Fee__c),
                      "docFee": String(varCustomSettingSobjRegFeeP.BOATBUILDING__Doc_Fee__c),
                      "trlRegFee": String(varCustomSettingSobjRegFeeP.BOATBUILDING__Trailer_Registration_Fee__c),
                      "lstProductPrice": lstProductPriceIdList,
                      "lstDealerOption": lstDealerOptionIdList,
                      "objQT": objQTRR,
                      "lstDO": JSON.stringify(DealerOptionList)
                      
                  });
                  
                  action.setCallback(this, function(res) {
                      var state = res.getState();
                      console.log(res.getReturnValue());
                      document.getElementById("qtSpinnerWiz").style.display = 'none';
                      if(state == 'SUCCESS') {
                          if(res.getReturnValue() != null) {
                              console.log(component.get("v.ObjQuote"));
                              component.set("v.ObjQuote", res.getReturnValue());
                              console.log(component.get("v.ObjQuote"));
                              component.set("v.fromBBNav", true);
                              
                              if(res.getReturnValue() != null) {
                                  var qtId = res.getReturnValue().Id;
                                  var urlEvent = $A.get("e.force:navigateToURL");
                                  window.onbeforeunload = null;
                                  $A.get('e.force:refreshView').fire();
                                  urlEvent.setParams({
                                      "url": '/'+qtId
                                  });
                                  urlEvent.fire();
                                  $A.get("e.force:closeQuickAction").fire();
                              }
                              
                              //var cmpEvent = $A.get("e.c:QuoteEvent");
                              
                              //cmpEvent.setParams({ 
                              //"ObjQuote": res.getReturnValue()
                              //});
                              //cmpEvent.fire();
                              
                              helper.callNext(component, event, ctarget.dataset);
                          } else {
                              var toastEvent = $A.get("e.force:showToast");
                              toastEvent.setParams({
                                  "title": "Error!",
                                  "message": "Something went wrong please try again.",
                                  "duration":"5000",
                                  "key": 'info_alt',
                                  "type": 'error',
                                  "mode": 'dismissible'
                              });
                              toastEvent.fire();
                          }
                          
                      }  
                  })
                  $A.enqueueAction(action);
                  //helper.callNext(component, event, ctarget.dataset);
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
      
  }
 })