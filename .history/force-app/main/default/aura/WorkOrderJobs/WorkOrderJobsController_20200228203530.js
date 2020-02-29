({
    doInit : function(component, event, helper) {
        console.log('woj', JSON.stringify(component.get("v.WOJ")));
        console.log('jli', component.get("v.jobLI"));
        if(component.get("v.recordType") == 'Warranty Work Order'){
            component.set("v.WOJ.BOATBUILDING__Taxable__c", false);
        }
        component.set("v.WOJ.partsTotal",0.00);
        
        var wtMap = [];
                var result = component.get("v.mapWTP");
                console.log('v.mapWTP', result);
                for(var key in result){
                    wtMap.push({key: key, value: result[key]});
                }
                component.set("v.mapWTPNew", wtMap);
                console.log(component.get("v.mapWTPNew"));


                var cjMap = [];
                var resultCannedJob = component.get("v.mapCannedJob");
                console.log('v.mapCannedJob', JSON.stringify(resultCannedJob));
                for(var key in resultCannedJob){
                    cjMap.push({key: resultCannedJob[key].BOATBUILDING__Job_Name__c, value: key});
                }
                component.set("v.mapCannedJobId", cjMap);
                console.log(component.get("v.mapCannedJobId"));

                var seelctedWT = component.get("v.WOJ.BOATBUILDING__Work_Type__c");
                var multiplier = component.get("v.mapWTP")[component.get("v.WOJ.BOATBUILDING__Work_Type__c")];
                component.set("v.laborPriceMultiplier",multiplier);
                component.set("v.WOJ.laborPriceMultiplier",multiplier);
                var wojli =  component.get("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r");
            var partsTotal = 0.00;
            if(wojli != '' && wojli != undefined && wojli != 'undefined'){
                for(var i = 0; i < wojli.length; i++){
                    partsTotal = partsTotal + wojli[i].BOATBUILDING__Price__c * wojli[i].BOATBUILDING__Quantity__c;
                }

                component.set("v.partsTotal",partsTotal);
                
                component.set("v.WOJ.partsTotal",partsTotal);

              
            }
            helper.updatejobTotalHelper(component, event, helper);


            if(component.get("v.WOJ.BOATBUILDING__Technician__c") != undefined && component.get("v.WOJ.BOATBUILDING__Technician__c") != 'undefined' && component.get("v.WOJ.BOATBUILDING__Technician__c") != ''){
                component.set("v.selectedRecord",component.get("v.WOJ.BOATBUILDING__Technician__r.Name"));
                component.set("v.showPill", true);
                component.set("v.selectedRecordId",component.get("v.WOJ.BOATBUILDING__Technician__c"));
            }
    },
    cannedJobToggle : function(component, event, helper){
       var isChecked =  component.find("cannedJobToggelBox").getElement().checked;
       component.set("v.isCannedJob",isChecked);
    },
    cannedJobSelected : function(component, event, helper){
       var cannedJobName = component.find("cannedJobList").get("v.value");
       if(cannedJobName != '' && cannedJobName != undefined){
           component.set("v.cannedJobSelected", true);
           
           var JobObject = component.get("v.mapCannedJob")[cannedJobName];
           console.log('JobObject',JSON.stringify(component.get("v.mapCannedJob")));
           component.set("v.WOJ",JobObject);
           component.set("v.WOJ.BOATBUILDING__Work_Type__c",JobObject.BOATBUILDING__Work_Type__c)
           var multiplier = component.get("v.mapWTP")[component.get("v.WOJ.BOATBUILDING__Work_Type__c")];
           console.log('multiplier',component.get("v.mapWTPNew"));
           component.set("v.laborPriceMultiplier",multiplier);
       }
       else{
        component.set("v.cannedJobSelected", false);
       }
       //component.set("v.isCannedJob",isChecked);
    },
    workTypeChanged : function(component, event, helper){
        var multiplier = component.get("v.mapWTP")[component.get("v.WOJ.BOATBUILDING__Work_Type__c")];
        component.set("v.laborPriceMultiplier",multiplier);
        component.set("v.WOJ.laborPriceMultiplier",multiplier);
        helper.updatejobTotalHelper(component, event, helper);
    },
    addNewMiscCharge : function(component, event, helper){
        var miscCount = component.get("v.noOfMiscCharges");
        if(miscCount+1 == 2 ||  component.get("v.displayMisc3") == true){

            component.set("v.displayMisc2",true);
        }
        if(miscCount+1 == 3){
            component.set("v.displayMisc3",true);
        }
        if(miscCount < 3){
            component.set("v.noOfMiscCharges",miscCount+1);
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Misc Charges Limit exceeded!",
                "type":"info",
                "mode":"warning",
                "message": "You can only add up to 3 Misc Charges"
            });
            toastEvent.fire();
        }
        

    },
    addMiscCharges : function(component, event, helper){
        helper.addMiscTotal(component, event, helper);
    },
    removeMisc2 : function(component, event, helper){
        component.set("v.displayMisc2",false);
        var miscCount = component.get("v.noOfMiscCharges");
        component.set("v.WOJ.BOATBUILDING__Misc_Charge_2__c",0.00);
        component.set("v.WOJ.BOATBUILDING__Misc_Description_2__c", '');
            component.set("v.noOfMiscCharges",2);
            helper.addMiscTotal(component, event, helper);
            helper.updatejobTotalHelper(component, event, helper);   
        
    },
    removeMisc3 : function(component, event, helper){
        component.set("v.displayMisc3",false);
        var miscCount = component.get("v.noOfMiscCharges");
        component.set("v.WOJ.BOATBUILDING__Misc_Charge_3__c",0.00);
        component.set("v.WOJ.BOATBUILDING__Misc_Description_3__c", '');
        if(miscCount-1 >= 1){ 
            component.set("v.noOfMiscCharges",2);
            
        }

        helper.addMiscTotal(component, event, helper);
        helper.updatejobTotalHelper(component, event, helper);
        
    },
    addNewJobLineItems : function(component, event, helper){
        var newLineItem = new Object();
        newLineItem.BOATBUILDING__Related_to_Job__c = component.get("v.WOJ.Id");
        newLineItem.BOATBUILDING__Price__c = 0.00;
        newLineItem.BOATBUILDING__Quantity__c = 0;

        var jobLineItems = component.get("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r") != undefined ? component.get("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r") : [];
        
        jobLineItems.push(newLineItem);
        component.set("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r",jobLineItems);

    },
    handleRemoveJobLineItems : function(component, event, helper){
       
            var self = this;  // safe reference
    
            var index = event.target.dataset.index;
            var value = event.target.dataset.value;
            console.log(index +'----'+value);
            helper.removeJobLineItem(component, index);
            if(typeof value != "undefined"){
                var deleteAction =  component.get("c.deleteJobLineItem ");
                deleteAction.setParams({
                    "jliId" : value
                });
                deleteAction.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The part has been deleted from Work Order Job!",
                            "type": "success"
                        });
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(deleteAction);
            }
        
    },
    joblineItemTotal : function(component, event, helper){
        var wojli =  component.get("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r");
        var partsTotal = 0.00;
        if(wojli != '' && wojli != undefined && wojli != 'undefined'){
            
            for(var i = 0; i < wojli.length; i++){
                var recordType = component.get("v.recordType");
                if(typeof recordType != "undefined"){
                    if(recordType == 'Work Order'){
                        partsTotal = partsTotal + wojli[i].BOATBUILDING__Price__c * wojli[i].BOATBUILDING__Quantity__c;
                    }
                    else{
                        partsTotal = partsTotal + wojli[i].BOATBUILDING__Dealer_Price__c * wojli[i].BOATBUILDING__Quantity__c;

                    }
                   
                }
                
            }
            if(component.isValid()){
                component.set("v.partsTotal",partsTotal);
                if(typeof component.get("v.WOJ") != "undefined"){
                    component.set("v.WOJ.partsTotal",partsTotal);
                }
                console.log('calling JOb Total if');
                helper.updatejobTotalHelper(component, event, helper);
            }
           
        }else{
            if(component.isValid()){
                component.set("v.partsTotal",0.00);
                
                if(typeof component.get("v.WOJ") != "undefined"){
                    component.set("v.WOJ.partsTotal",0.00);
                }
                console.log('calling JOb Total');
               helper.updatejobTotalHelper(component, event, helper);
            }
        }

    },
    updateJObTotal : function(component, event, helper){
       helper.updatejobTotalHelper(component, event, helper);
    },
    handleKeyUp: function (cmp, evt, helper) {
        var isEnterKey = evt.keyCode === 13;
       
            var queryTerm = cmp.find('enter-search-user').get('v.value');
            if(queryTerm.length > 4){
                helper.searchUsers(cmp, evt, helper);
                var results = [];

                var result1 = {};
                result1.Id = '1';
                result1.Name='Ajay';
        
                var result2 = {};
                result2.Id = '1';
                result2.Name='Sajal';
                results.push(result1);
                results.push(result2);
                //cmp.set("v.searchResults", results);  
            }
        
    }, 
    searchUserOnFocus: function (component, event, helper) {
        
        var searchAction = component.get("c.loadSrviceUsers");
       
        searchAction.setCallback(this, function(response){
                console.log('searchResult',response.getReturnValue());
                component.set("v.searchResults", response.getReturnValue());
        });

        $A.enqueueAction(searchAction);
            
        
    }, 
    itemSelected : function(component, event, helper){
        console.log('liselected',JSON.stringify(event.target.dataset));
        var label = event.currentTarget.dataset.label;
        var value = event.currentTarget.dataset.value;
        //alert(label+'---'+value);
        component.set("v.selectedRecord",label);
       component.set("v.showPill", true);
       component.set("v.selectedRecordId",value);
       
       var searchResultArray = component.get("v.searchResults");
       console.log('searchResultArray',searchResultArray);
       console.log('searchResultArrayValue',value);
       for(var i = 0; i < searchResultArray.length; i++){
        console.log('selectedpartsbefore',searchResultArray[i]);
            if(searchResultArray[i].Id == value){
                console.log('selectedparts',searchResultArray[i]);
                component.set("v.WOJ.BOATBUILDING__Technician__c",searchResultArray[i].Id);
                break;
            }
           
       }

       
    },
    pillRemoved : function(component, event, helper){
        component.set("v.selectedRecordId",'');
        component.set("v.WOJ.BOATBUILDING__Technician__c",''); 
       component.set("v.selectedRecord",'');
       component.set("v.showPill", false);
       component.set("v.searchResults", []);  
    },
    calculateTaxOnJOb : function(component, event, helper){
        if(component.get("v.recordType") != 'Warranty Work Order'){
            var storeLocationVal = event.getParams();
            console.log('epObject',JSON.stringify(storeLocationVal));
                console.log('ep',storeLocationVal.storeLocation);
            //helper.updatejobTotalHelper(component, event, helper);
            helper.jobTaxCalcualtion(component, event, helper, storeLocationVal.storeLocation);
        }
        
        
    },
    updatePartsTotal : function(component, event, helper){
      //  helper.updatejobTotalHelper(component, event, helper);
    },
    saveJob : function(component, event, helper){
        helper.saveJobWithJLI(component, event, helper);
    },
    calcualteTotalPaidWarranty : function(component, event, helper){
        var claimPaid = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c") ;
        var partPaid = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Parts_Paid_Amount__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Parts_Paid_Amount__c");
        var miscPaid = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge_Paid__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge_Paid__c");
        var shippingCharge = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c");
        var discount = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Discount__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Discount__c");

        var totalPaid = parseFloat(claimPaid)+parseFloat(partPaid)+parseFloat(miscPaid) + parseFloat(shippingCharge) - parseFloat(discount);
        
       
        
        if(!isNaN(totalPaid)){
            component.set("v.WOJ.BOATBUILDING__Total_Paid__c",totalPaid);
           // helper.updatejobTotalHelper(component, event, helper);
            
        }
        
    }

})