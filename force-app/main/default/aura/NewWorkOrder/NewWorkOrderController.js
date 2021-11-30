({
    doInit: function( component, event, helper ) {
        // var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        // alert('test***' + recordTypeId);
        var action = component.get("c.getPageLayoutFields");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                // alert(response.getReturnValue());
                component.set("v.layoutSections", response.getReturnValue() );              
            }
            
        });
        
        $A.enqueueAction(action);
        
        
        
    },
    
    
    onAccountSelect : function(component, event, helper) {
        component.set("v.disableSelectItem", false );
        component.set("v.showspinner", true);
        var AccId = String(component.get("v.AccountId"));
        
        
        var action = component.get("c.getAccountRelatedItems");
        action.setParams({
            "recId" : AccId
        });
        action.setCallback(this, function(response) {
            //console.log("v.layoutSections", response.getReturnValue() );
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                if(result.length == 1){
                    
                    component.set("v.ItemId",result[0].Id);
                    component.set("v.disableSelectItem",true);
                    
                }else{
                    component.set("v.ItemId", null);
                }
                
                // alert(result);
                component.set("v.options", response.getReturnValue() );
                component.set("v.Itemoptions", response.getReturnValue() );
                component.set("v.showspinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
        //  }
        
    },
    
    onworkOrderAccountSelect : function(component, event, helper) {
        component.set("v.disableSelectItem", false );
        component.set("v.showspinner", true);
        var AccId = String(component.get("v.selectedAccountId"));
        //  if(AccId != null && AccId ){
        
        var action = component.get("c.getAccountRelatedItems");
        action.setParams({
            "recId" : AccId
        });
        action.setCallback(this, function(response) {
            //console.log("v.layoutSections", response.getReturnValue() );
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                if(result.length == 1){
                    
                    component.set("v.ItemIdForWWO",result[0].Id);
                    component.set("v.selectedValue",result[0].Name);
                    component.set("v.disableSelectItem",true);
                    
                }else{
                    component.set("v.ItemIdForWWO", null);
                }
                component.set("v.options", response.getReturnValue() );
                component.set("v.Itemoptions", response.getReturnValue() );
                component.set("v.showspinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
        //   }else{
        
        // }
        
    },
    handleSelect : function(component, event, helper) {
        // alert(component.find("mySelect1").get("v.value")); 
        component.set("v.showspinner", true);
        component.set("v.ItemId",component.find("mySelect1").get("v.value"));
        component.set("v.showspinner", false);
        
    },
    handleSelect2 : function(component, event, helper) {
        component.set("v.ItemIdForWWO",component.find("mySelect2").get("v.value"));
        
    },
    
    onRecordTypeselect : function(component, event, helper) {
        
        component.set("v.showspinner", true);
        // component.set("v.ShowRadiobtn",true);
        var action = component.get("c.getRecordType");
        action.setParams({
            "RecTy" : component.get("v.selectedRecordId")
        });
        action.setCallback(this, function(response) {
            //console.log("v.layoutSections", response.getReturnValue() );
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.showspinner", false);
                var result = response.getReturnValue();
                //  alert(result[0].Name);
                component.set("v. recordType",result[0].Name);
                component.set("v.SelectedRecordType",result);
                
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    }, 
    handleSuccess : function(component, event, helper) {
        component.set("v.showspinner", false);
        var payload = event.getParams().response;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The Work request has been saved.",
            "type": "success"
        });
        toastEvent.fire();
        component.set("v.showspinner", false);
        var navLink = component.find("navService");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'BOATBUILDING__Work_Order__c',
                recordId : payload.id
            },
        };
        navLink.navigate(pageRef, false);
    },
    handleSubmit: function(component, event, helper) {
        component.set("v.showspinner", true);
        component.find('workrequest').submit();
    },
    handleWorkorderSubmit : function(component, event, helper) {
        component.set("v.showspinner", true);
        component.find('workorder').submit();
    },
    
    onItemchange : function(component, event, helper) {
        //  alert(component.get("v.ItemId")) ;
        var action = component.get("c.getItemsDetail");
        action.setParams({
            "itemId" : component.get("v.ItemId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.ItemDetail", response.getReturnValue());
                
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    onChangeOfAssignedto: function(component, event, helper) {
        // alert(component.get("v.Assignedto"));
        component.set("v.showspinner", true);
        var action = component.get("c.getStoreLocation");
        
        action.setParams({  
            "UserId" : String(component.get("v.Assignedto"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            
            if (state === "SUCCESS") {
                if(result != null){
                    component.set("v.UserStoreLoc", response.getReturnValue());
                    component.set("v.showspinner", false);
                }
                
            }else{
                component.set("v.showspinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
        component.set("v.showspinner", false);
    },
    
    onChangeOfContact: function(component, event, helper) {
        
        component.set("v.disableSelectItem", false );
        var AccId = component.get("v.AccountId");
        console.log('AccId: ',JSON.stringify(AccId));
        component.set("v.showspinner", true);
        var action = component.get("c.getItemFromContact");
        action.setParams({
            "ContactId" : String(component.get("v.contactValue"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result){
                    if(result.lstItem.length == 1){
                        if( typeof result.lstItem[0].BOATBUILDING__Account__c !== 'undefined'){
                            component.set("v.AccountId", result.lstItem[0].BOATBUILDING__Account__c );
                            
                        }
                        if(result.lstItem[0].Id != undefined){
                            component.set("v.ItemId",result.lstItem[0].Id);
                        }
                        component.set("v.disableSelectItem",true);
                        
                        
                    }else{
                        component.set("v.ItemId", null);
                    }
                    
                    if(result.lstItem.length > 0 && typeof result.lstItem[0].BOATBUILDING__Account__c !== 'undefined' && result.itemIsAvailble !== false){
                        component.set("v.AccountId", result.lstItem[0].BOATBUILDING__Account__c );
                    }
                    component.set("v.options",result.lstItem );
                    component.set("v.Itemoptions",result.lstItem);
                    component.set("v.showspinner", false);
                    
                }
            }else if (status === "ERROR") {
                component.set("v.showspinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
        
        
    },
    
    
    
    
})