({
    getWOJobs : function(component, event, helper) {
        component.set("v.toggleSpinner2", true);
        var getjobs = component.get("c.getWorkOrderJobs");
        getjobs.setParams({
            "woId":component.get("v.recordId")
        });
        getjobs.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                //console.log('---------------wojwithJLI',JSON.stringify(response.getReturnValue() ));
                
                component.set("v.woJobsWithWJL",response.getReturnValue());
              
               
                this.taxCalculation(component, event, helper); 
                component.set("v.toggleSpinner2", false);
                
            }
            else{
                //console.log(JSON.stringify(response.getError()));
                component.set("v.toggleSpinner2", false);
            }
            
            
        });
        $A.enqueueAction(getjobs);
        
    }, 
    
    getNewWOJ : function(component, event, helper){
        this.showSpinner(component, event, helper);
        var getNewWOJ = component.get("c.getNewWOJobInstance");
        getNewWOJ.setParams({
            "woId":component.get("v.recordId")
        });
        getNewWOJ.setCallback(this, function(response){
            //console.log(response.getReturnValue());
            component.set("v.toggleSpinner2", false);
            var woJobs = component.get("v.woJobsWithWJL");
            //console.log('woJobsssss',woJobs);
            var newJob = response.getReturnValue();
            //newJob.objWOJ.RecordType.Name = component.get("v.woRecordData").RecordType.Name;
            //newJob.ObjWOJ.BOATBUILDING__Store_Location__c = component.get("v.woRecordData").BOATBUILDING__Store_Location__c;
            //newJob.ObjWOJ.BOATBUILDING__Store_Location__c = component.find("storeLocationWO").get("v.value");
           // console.log('component.get("v.woRecordData")',JSON.stringify(component.get("v.woRecordData")));
            //console.log('component.find("storeLocationWO").get("v.value")',component.find("storeLocationWO").get("v.value"));
            if(component.get("v.woRecordData.RecordType.Name") == 'Warranty Work Order'){
                newJob.objWOJ.BOATBUILDING__Taxable__c = false;
            }
            newJob.objWOJ.BOATBUILDING__Approved_By_Customer__c = false;
            woJobs.push(newJob);
            component.set("v.woJobsWithWJL",woJobs);
            var index = parseInt(woJobs.length)-1;
            //console.log('length',index);
            var divId = "divTOScroll"+index;
            //console.log('ledivIdngth',divId);
            var objDiv = document.getElementById("divTOScroll");
            objDiv.scrollIntoView(); 
            this.hideSpinner(component,event,helper);
            //here i am trying to scroll down the page to see the new job section
        }); 
        $A.enqueueAction(getNewWOJ);
    }, 
    removeJobsHelper : function(component, index, helper) {
        var woJobs = component.get("v.woJobsWithWJL");

        woJobs.splice(index, 1);
        component.set("v.woJobsWithWJL", woJobs);
        
    },
    calculateTotalJobs : function(component, event, helper){
        //this.showSpinner(component,event,helper);
        var woJobWithJL = component.get("v.woJobsWithWJL");
        
        //console.log('woJobWithJL',woJobWithJL);
        var internalTotal = 0.00;
        var ExternalTotal = 0.00;

        var jobTotal = 0.00;

        for(var i = 0; i < woJobWithJL.length; i++){
            jobTotal = parseFloat(jobTotal)+parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Total_Amount_Job__c);
            console.log('jobbbbbbbbtotalINternalExtarnal',woJobWithJL[i].objWOJ);
            if(typeof woJobWithJL[i].objWOJ != "undefined" && typeof woJobWithJL[i].objWOJ.BOATBUILDING__Work_Type__c != "undefined"){
                var workType = woJobWithJL[i].objWOJ.BOATBUILDING__Work_Type__c;
                if(workType.includes('Internal') || workType.includes('internal')){
                    if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c != "undefined" && typeof woJobWithJL[i].objWOJ.laborPriceMultiplier != "undefined")
                    internalTotal = internalTotal + (woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c * woJobWithJL[i].objWOJ.laborPriceMultiplier);
                }
                else{
                    if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c != "undefined" && typeof woJobWithJL[i].objWOJ.laborPriceMultiplier != "undefined")
                    ExternalTotal = ExternalTotal + (woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c * woJobWithJL[i].objWOJ.laborPriceMultiplier);
                }
            }
           
        }
        
        
        component.set("v.InternallaborTotal", internalTotal);
        component.set("v.externalLaborTotal",ExternalTotal);
        jobTotal = jobTotal.toFixed(2);
        //component.set("v.woJobsWithWJL",woJobWithJL);
        if(woJobWithJL.length < 1){
            component.set("v.workOrderTotal",0.00);
        }else{
            component.set("v.workOrderTotal",jobTotal);
        }
       
        //component.set("v.workOrderTotalwTax",jobTotal);
       // //console.log('storeLocation--------',component.find("storeLocationWO").get("v.value"));
        var storeLocation;
        if(typeof component.find("storeLocationWO") != "undefined"){
            storeLocation = component.find("storeLocationWO").get("v.value");
           //console.log('Storelocation if', storeLocation);
           
        }
        else{
            storeLocation = component.get("v.woRecordData.BOATBUILDING__Store_Location__c");
            if(typeof storeLocation == "undefined" && typeof component.get("v.woJobsWithWJL") != "undefined" && component.get("v.woJobsWithWJL").length > 0){
                storeLocation = component.get("v.woJobsWithWJL")[0].objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c;
                
            }
          
            //console.log('Storelocation else', storeLocation);
        }
        if(typeof storeLocation != "undefined"){
            if(component.get("v.woRecordData.RecordType.Name") != 'Warranty Work Order'){
            
                this.taxCalculation(component, event, helper);
                //component.set("v.toggleSpinner2", false);
            }else{
                component.set("v.workOrderTotalwTax",jobTotal);
                //console.log('RT Name', component.get("v.woRecordData.RecordType.Name"));
                //this.hideSpinner(component,event,helper);
            }

            //console.log('Event storeLocation',storeLocation);
            var oldStoreLocation = component.get("v.storeLocationVal");
            if(oldStoreLocation != storeLocation){
                var appEvent = $A.get("e.c:CalculateTaxOnWOJObs");
                appEvent.setParams({
                    "storeLocation" : storeLocation  
                });
                appEvent.fire();
                component.set("v.storeLocationVal", storeLocation);
            }
            
        }else{
            //console.log('did not enter in if');
        }
        helper.calculateWoComponents(component, event, helper);
    },
    calculateWoComponents : function(component, event, helper){
        var partsTotalOnWorkOrder = 0.00;
        var totalLabor = 0.00;
        var totalMiscChargesWO = 0.00;
        var totalShopSupplies = 0.00;
        var totalDiscountOnWorkOrderJobs = 0.00;
        var totalShippingCharges = 0.00;
        var woJobWithJL = component.get("v.woJobsWithWJL");
        var totalClaimPaid = 0.00;
        for(var i = 0; i < woJobWithJL.length ; i++){
            if(typeof woJobWithJL[i].objWOJ.partsTotal != "undefined"){
                partsTotalOnWorkOrder = partsTotalOnWorkOrder + woJobWithJL[i].objWOJ.partsTotal;
            }  
            if(typeof woJobWithJL[i].objWOJ.laborPriceMultiplier != "undefined" && typeof woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c != "undefined"){
                totalLabor = parseFloat(totalLabor) + (parseFloat(woJobWithJL[i].objWOJ.laborPriceMultiplier) * parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c));
            }
            if(typeof woJobWithJL[i].objWOJ.totalMiscCharges != "undefined"){
                totalMiscChargesWO = parseFloat(totalMiscChargesWO) + parseFloat(woJobWithJL[i].objWOJ.totalMiscCharges); 
            }
            if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Shop_Supplies_Total__c != "undefined" ){
                totalShopSupplies = parseFloat(totalShopSupplies) + parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Shop_Supplies_Total__c);
            }
            if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Discount__c != "undefined"){
                totalDiscountOnWorkOrderJobs = parseFloat(totalDiscountOnWorkOrderJobs) + parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Discount__c);
            }
            if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Shipping_Charge__c != "undefined"){
                totalShippingCharges = parseFloat(totalShippingCharges) + parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Shipping_Charge__c);
            }
           
            if(component.get("v.recordType") == 'Warranty Work Order'){
                if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Total_Paid__c != "undefined"){
                    totalClaimPaid = parseFloat(totalClaimPaid) + woJobWithJL[i].objWOJ.BOATBUILDING__Total_Paid__c;
                }
            }
        }
        //console.log('component.get("v.recordType")component.get("v.recordType")',component.get("v.recordType"));
        component.set("v.partsTotalOnWorkOrder",partsTotalOnWorkOrder);
        component.set("v.totalLabor",totalLabor);
        component.set("v.totalMiscChargesWO",totalMiscChargesWO);
        component.set("v.totalShopSupplies",totalShopSupplies);
        component.set("v.totalDiscountOnWorkOrderJobs",totalDiscountOnWorkOrderJobs);
        component.set("v.totalShippingCharges",totalShippingCharges);
        component.set("v.totalClaimPaid",totalClaimPaid);

    },
    taxCalculation : function(component, event, helper){
       
        //console.log('woRecordData',JSON.stringify(component.get("v.woRecordData")));
        //console.log('after Save Button%%%%%%%%%%',JSON.stringify(component.get("v.woJobsWithWJL")));
        // //console.log('storeLocation',component.find("storeLocationWO").get("v.value"));
        var storeLocation = component.find("storeLocationWO");
    
       
        if(typeof storeLocation == "undefined"){
            //console.log('firstIF Line 150 wodhelper');
            storeLocation = component.get("v.woRecordData.BOATBUILDING__Store_Location__c");
            if(typeof storeLocation == "undefined" && typeof component.get("v.woJobsWithWJL") != "undefined" && component.get("v.woJobsWithWJL").length > 0){
                //console.log('2dIF Line 153 wodhelper');
                storeLocation = component.get("v.woJobsWithWJL")[0].objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c;
                
            }
        }else{
            //console.log('3rdelse Line 158 wodhelper');
            storeLocation = storeLocation.get("v.value");
            //console.log('3rdelse Line 158 wodhelper',storeLocation);
            if(typeof storeLocation == "undefined"){
               
                storeLocation = component.get("v.woRecordData.BOATBUILDING__Store_Location__c");
                if(typeof storeLocation == "undefined" && typeof component.get("v.woJobsWithWJL") != "undefined" && component.get("v.woJobsWithWJL").length > 0){
                  
                    storeLocation = component.get("v.woJobsWithWJL")[0].objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c;
                    
                }
            }

        }
        //console.log('lije 136 WorkOrderDetailHelper',storeLocation);
        if(typeof storeLocation != "undefined"){
            //console.log('*********', component.find("storeLocationWO"));
           
            
            //BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c
            var woJobWithJL = component.get("v.woJobsWithWJL");
            if(typeof storeLocation == "undefined" && typeof woJobWithJL != "undefined" && woJobWithJL.length > 0 && typeof woJobWithJL[0].objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c != "undefined"){
                storeLocation = woJobWithJL[0].objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c;
            }
            var salestaxConfig;
            if(typeof woJobWithJL != "undefined" && typeof woJobWithJL != "undefined" && woJobWithJL.length > 0 &&  typeof woJobWithJL[0].salesTaxConfig != "undefined"){
                salestaxConfig = woJobWithJL[0].salesTaxConfig;
            }   
            
            if( typeof salestaxConfig != "undefined" && typeof storeLocation != "undefined" && typeof salestaxConfig[storeLocation] != "undefined"  ){
                var salestaxPercent = salestaxConfig[storeLocation].BOATBUILDING__Regular_Sales_Tax__c;
                var taxInfo = "The tax is "+salestaxPercent+"% of the total taxable amount";
                component.set("v.taxRate",taxInfo);
                
                var isPartTaxable = salestaxConfig[storeLocation].BOATBUILDING__Part_Tax__c;
                var isMiscTaxable = salestaxConfig[storeLocation].BOATBUILDING__Misc_Tax__c;
                var islaborTaxable = salestaxConfig[storeLocation].BOATBUILDING__Labor_Tax__c;
                var isShopSuppliesTaxable = salestaxConfig[storeLocation].BOATBUILDING__Shop_Supplies_Tax__c;
                //console.log('salestaxConfigMap',salestaxConfig[storeLocation]);
                var partsTotalOnWorkOrder = 0.00;
                var totalMiscChargesWO = 0.00;
                var totalLabor = 0.00;
                var shopSupplies = 0.00;
                var totalDiscountOnWorkOrderJobs = 0.00;
                var taxableTotal = 0.00;
                var totalShippingCharges = 0.00;
                
                for(var i = 0; i < woJobWithJL.length ; i++){  
                    //console.log('i'+i);
                    if(woJobWithJL[i].objWOJ.BOATBUILDING__Taxable__c == true){
                        //woJobWithJL[i].objWOJ.
                        if(typeof woJobWithJL[i].objWOJ.partsTotal != "undefined"){
                           // console.log('----------partsTotal',woJobWithJL[i].objWOJ.partsTotal);
                            partsTotalOnWorkOrder = partsTotalOnWorkOrder + woJobWithJL[i].objWOJ.partsTotal;
                            //console.log('----------partsTotalAfter',partsTotalOnWorkOrder);
                        }
                        //console.log('woJobWithJL[i].objWOJ.laborPriceMultiplier',JSON.stringify(woJobWithJL[i].objWOJ));
                        
                        if(typeof woJobWithJL[i].objWOJ.laborPriceMultiplier != "undefined" && typeof woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c != "undefined"){
                            //console.log('----------inside Labor');

                            totalLabor = parseFloat(totalLabor) + (parseFloat(woJobWithJL[i].objWOJ.laborPriceMultiplier) * parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__No_of_Labors__c));
                           // console.log('----------inside Labor',totalLabor);
                        }
                        
                        if(typeof woJobWithJL[i].objWOJ.totalMiscCharges != "undefined"){
                            totalMiscChargesWO = parseFloat(totalMiscChargesWO) + parseFloat(woJobWithJL[i].objWOJ.totalMiscCharges); 
                        }
                        
                        
                        if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Shop_Supplies_Total__c != "undefined" ){
                            //console.log('----------inside SS');
                            shopSupplies = parseFloat(shopSupplies) + parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Shop_Supplies_Total__c);
                        }
                        if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Discount__c != "undefined"){
                            totalDiscountOnWorkOrderJobs = parseFloat(totalDiscountOnWorkOrderJobs) + parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Discount__c);
                        }
                        if(typeof woJobWithJL[i].objWOJ.BOATBUILDING__Shipping_Charge__c != "undefined"){
                            totalShippingCharges = parseFloat(totalShippingCharges) + parseFloat(woJobWithJL[i].objWOJ.BOATBUILDING__Shipping_Charge__c);
                        }
                    }
                }
                
                //console.log('totalLabor**********************', totalLabor);
                //console.log('totalMiscChargesWO**********************', totalMiscChargesWO);
                //console.log('totalShippingCharges**********************', totalShippingCharges);
                var taxableItems = "The taxable Items are :";
                var nontaxableItems = "The Non-Taxable Items are :";
                if(isPartTaxable == true){
                    taxableItems = taxableItems+" Parts,";
                    taxableTotal = parseFloat(taxableTotal) + parseFloat(partsTotalOnWorkOrder);
                    //console.log('parts are taxable',taxableTotal);
                }
                else{
                    nontaxableItems = 'Parts,';
                }
                if(isShopSuppliesTaxable == true){
                    taxableItems = taxableItems+" Shop Supplies,";
                    taxableTotal = parseFloat(taxableTotal) + parseFloat(shopSupplies);
                    //console.log('shopSupplies are taxable',taxableTotal);
                }
                else{
                    nontaxableItems += 'Shop Supplies,';
                }
                if(islaborTaxable == true){
                    taxableItems = taxableItems+" Labor,";
                    taxableTotal = parseFloat(taxableTotal) + parseFloat(totalLabor);
                    //console.log('labor are taxable', taxableTotal);
                }
                else{
                    nontaxableItems += 'Laber,';
                }
                if(isMiscTaxable == true){
                    taxableItems = taxableItems+" Misc Charges.";
                    taxableTotal = parseFloat(taxableTotal) + parseFloat(totalMiscChargesWO);
                    //console.log('Misc are taxable',taxableTotal);
                }else{
                    nontaxableItems += 'Misc Charges,';
                }
                
                    nontaxableItems += 'Shipping Charges.';
                 
                
                component.set("v.nontaxableItems",nontaxableItems);
                var str = taxableItems;
                var word = ',';
                var newWord = ' &';
                
                // find the index of last time word was used
                // please note lastIndexOf() is case sensitive
                var n = str.lastIndexOf(word);
                
                // slice the string in 2, one from the start to the lastIndexOf
                // and then replace the word in the rest
                str = str.slice(0, n) + str.slice(n).replace(word, newWord);
                component.set("v.taxableAmountDetails",str);
                taxableTotal = parseFloat(taxableTotal) - parseFloat(totalDiscountOnWorkOrderJobs);
                component.set("v.taxableTotal",taxableTotal);
                //console.log('taxableTotal',taxableTotal);
                
                var totalTax = (parseFloat(taxableTotal)/100) * parseFloat(salestaxPercent);
                component.set("v.totalTaxonWO",totalTax);
                var jobTot = component.get("v.workOrderTotal");
                var totalwTax = parseFloat(jobTot) + parseFloat(totalTax) + parseFloat(totalShippingCharges);
                //console.log('jobtot',jobTot);
                //console.log('jobtot',totalTax);
                if(!isNaN(totalwTax)){
                    component.set("v.workOrderTotalwTax",totalwTax.toFixed(2));
                }
                this.hideSpinner(component,event,helper);
                //console.log('totaltax',totalTax); 
            }
            else{
                var jobTot = component.get("v.workOrderTotal");
                if(isNaN(jobTot)){
                    jobTot = 0.00;
                }
                component.set("v.workOrderTotalwTax",parseFloat(jobTot));
                component.set("v.taxableTotal",0.00);
                component.set("v.totalTaxonWO",0.00);
                //console.log('storeLocation?????',storeLocation);
                if(typeof storeLocation == "undefined" || storeLocation == '' || storeLocation == null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "Please Select Store Location in Work order detail section.",
                        "type": "warning",
                        
                    });
                    toastEvent.fire();
                }
                
                //console.log('else part',storeLocation);
               
            }
        } 
        else{
            //console.log('tax calculation else part');
        }
       
    },
    showSpinner : function(component, event, helper){
        // display spinner when aura:waiting (server waiting)
        //  component.set("v.toggleSpinner", true);  
        },
      hideSpinner : function(component, event, helper){
     // hide when aura:downwaiting
         // component.set("v.toggleSpinner", false);
          
      }
})