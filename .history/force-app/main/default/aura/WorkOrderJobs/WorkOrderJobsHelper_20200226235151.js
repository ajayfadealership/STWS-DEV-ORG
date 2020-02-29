({
    removeJobLineItem: function(component, index) {
        var woJobLineItems = component.get("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r");
        woJobLineItems.splice(index, 1);
        component.set("v.WOJ.BOATBUILDING__Work_Order_Job_Line_Items__r", woJobLineItems);
    },
    
    updatejobTotalHelper : function(component, event, helper){
        this.showSpinner(component,event,helper);
       console.log('line 10',component.get("v.WOJ.BOATBUILDING__No_of_Labors__c"));
       console.log('line 11',component.get("v.laborPriceMultiplier"));
        var totalLabor = component.get("v.WOJ.BOATBUILDING__No_of_Labors__c") * component.get("v.laborPriceMultiplier");
        console.log('TLlLLLLL', totalLabor);
        var misc1 = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge__c") ;
        var misc2 = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge_2__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge_2__c");
        var misc3 = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge_3__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge_3__c");
        var miscTotal = parseFloat(misc1)+parseFloat(misc2)+parseFloat(misc3);
        alert('this line executed 17');
        component.set("v.totalMiscCharges", miscTotal);
        alert('this line executed 19');
        component.set("v.WOJ.totalMiscCharges", miscTotal);
        alert('this line executed 21');
        var totalMisc = !isNaN(component.get("v.totalMiscCharges")) ? component.get("v.totalMiscCharges") : 0.00 ;
        alert('this line executed 23');
        var totalparts = !isNaN(component.get("v.partsTotal")) ? component.get("v.partsTotal") : 0.00;\

        console.log('$$$$$$$',totalparts);
        var shopSuppliescap = !isNaN(component.get("v.shopSuppliesCapping"))? component.get("v.shopSuppliesCapping") : 0.00;
        var shopSuppliesPer = !isNaN(component.get("v.shopSuppliePercent")) ? component.get("v.shopSuppliePercent") : 0.00;
        var ShippingCharges = !isNaN(component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c")) ? component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c") : 0.00 ;
        console.log('Shipping Charge'+ShippingCharges);
        var totalShopSupplies = 0.00;
        if(shopSuppliescap > 0.00 && !isNaN(totalLabor)){
            console.log('shopSuppliescap',shopSuppliescap);
            totalShopSupplies = (totalLabor/100) * shopSuppliesPer <= shopSuppliescap ? (totalLabor/100) * shopSuppliesPer : shopSuppliescap;

        }
        else if(totalLabor > 0.00 && !isNaN(totalLabor)){
            totalShopSupplies = (totalLabor/100) * shopSuppliesPer;
        }
       
        var jobTotal = 0.00;
        if(isNaN(totalLabor)){
            totalLabor = 0.00;
        }
       
        console.log('total labor'+component.get("v.WOJ.Name"),totalLabor);
        console.log('total Shop Suppllies',totalShopSupplies+'-----'+ShippingCharges);
        if(component.get("v.recordType") != "Warranty Work Order"){
            console.log('&&&',totalparts);
            if(!isNaN(totalLabor) && typeof totalLabor != "undefined"){
                jobTotal = jobTotal + parseFloat(totalLabor)
            }
            if(!isNaN(totalMisc) && typeof totalMisc != "undefined"){
                jobTotal = jobTotal + parseFloat(totalMisc)
            }
            if(!isNaN(totalparts) && typeof totalparts != "undefined"){
                jobTotal = jobTotal + parseFloat(totalparts)
            }
            if(!isNaN(totalShopSupplies) && typeof totalShopSupplies != "undefined"){
                jobTotal = jobTotal + parseFloat(totalShopSupplies)
            }
          
            var laborAndSS 
            if(typeof totalShopSupplies != "undefined" && typeof totalLabor != "undefined"){
                if(!isNaN(totalShopSupplies) && !isNaN(totalLabor)){
                    laborAndSS = totalShopSupplies + totalLabor;
                }
                
            }
            
            
            console.log('&&&',jobTotal);
            if(!isNaN(laborAndSS)){
               
                component.set("v.laborAndSSTotal",laborAndSS);
            }
        }
        else{
            
            if(!isNaN(totalLabor) && typeof totalLabor != "undefined"){
                jobTotal = jobTotal + parseFloat(totalLabor)
            }
            if(!isNaN(totalMisc) && typeof totalMisc != "undefined"){
                jobTotal = jobTotal + parseFloat(totalMisc)
            }
            if(!isNaN(totalparts) && typeof totalparts != "undefined"){
                jobTotal = jobTotal + parseFloat(totalparts)
            }
           
        }
        console.log('line 33'+jobTotal);
        var discount = component.get("v.WOJ.BOATBUILDING__Discount__c");
        console.log('total discount'+discount);
        if(!isNaN(discount)){
            jobTotal = parseFloat(jobTotal) - parseFloat(discount);
        }
        if(!isNaN(jobTotal) && typeof jobTotal != "undefined"){
            jobTotal = jobTotal.toFixed(2);
        }
       
      
        //  alert(component.get("v.WOJ"));
        if(component.get("v.WOJ") != undefined){
            if(typeof totalShopSupplies != "undefined" && component.get("v.recordType") != "Warranty Work Order"){
                component.set("v.WOJ.BOATBUILDING__Shop_Supplies_Total__c", totalShopSupplies.toFixed(2));
            }
            if(component.get("v.recordType") == "Warranty Work Order"){
               
                console.log("recordType***before",component.get("v.WOJ.BOATBUILDING__Total_Paid__c"));
                var totalClaimPaid =  component.get("v.WOJ.BOATBUILDING__Total_Paid__c");
                console.log("recordType********",totalClaimPaid);
                if(!isNaN(totalClaimPaid)){
                    console.log("recordType********",totalClaimPaid);
                    if(isNaN(jobTotal)){
                        jobTotal = 0.00;
                    }
                    console.log('jobTotal in warranty',jobTotal);
                   
                    console.log('jobTotal in warranty after Shipping',jobTotal);
                    jobTotal = parseFloat(jobTotal) + parseFloat(totalClaimPaid); 
                    jobTotal = jobTotal.toFixed(2);
                    
                }
                if(!isNaN(ShippingCharges) && typeof ShippingCharges != "undefined"){
                    jobTotal = parseFloat(jobTotal) + parseFloat(ShippingCharges);
                    jobTotal = jobTotal.toFixed(2);
                }
            }
            console.log("recordType????",component.get("v.recordType"));
            console.log('totalJob---'+jobTotal);
            if(!isNaN(jobTotal)){
                component.set("v.jobTotal",jobTotal);
                component.set("v.WOJ.BOATBUILDING__Total_Amount_Job__c",jobTotal);
            }
            else{
                console.log('111111',jobTotal);
                component.set("v.jobTotal",0.00);
                component.set("v.WOJ.BOATBUILDING__Total_Amount_Job__c",0.00);
            }
        
        
        }


        var calculateJobTotalEvent =  $A.get("e.c:CalculateAllJobsTotal");
        calculateJobTotalEvent.fire();

        //tax calcualtion per job
        var isJobTaxable = component.get("v.WOJ.BOATBUILDING__Taxable__c");
        if(isJobTaxable == true && component.get("v.recordType") != 'Warranty Work Order'){
            var storeLocation = component.get("v.WOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c")
            if(typeof storeLocation != "undefined"){
                this.jobTaxCalcualtion(component, event, helper, storeLocation);
            }
        }
        this.hideSpinner(component,event,helper);
        
    },
    addMiscTotal : function(component, event, helper){
        var misc1 = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge__c") ;
        var misc2 = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge_2__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge_2__c");
        var misc3 = isNaN(parseFloat(component.get("v.WOJ.BOATBUILDING__Misc_Charge_3__c"))) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Misc_Charge_3__c");
        var miscTotal = parseFloat(misc1)+parseFloat(misc2)+parseFloat(misc3);
        component.set("v.totalMiscCharges", miscTotal);
        component.set("v.WOJ.totalMiscCharges", miscTotal);
        this.updatejobTotalHelper(component, event, helper);
    },
    searchUsers : function(component, event, helper) {
        var searchAction = component.get("c.searchUsersApex");
        var queryTerm = component.find('enter-search-user').get('v.value');
        searchAction.setParams({
            "searchStr" : queryTerm
        });
        searchAction.setCallback(this, function(response){
                console.log('searchResult',response.getReturnValue());
                component.set("v.searchResults", response.getReturnValue());
        });

        $A.enqueueAction(searchAction);

    },
    jobTaxCalcualtion : function(component, event, helper, storeLocation){
        this.showSpinner(component,event,helper);
        var totalLabor = component.get("v.WOJ.BOATBUILDING__No_of_Labors__c") * component.get("v.laborPriceMultiplier");
        var totalMisc = component.get("v.totalMiscCharges");
        var totalparts = component.get("v.partsTotal");
        var ShippingCharges = isNaN(component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c")) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c");

        var shopSuppliescap = component.get("v.shopSuppliesCapping");
        var shopSuppliesPer = component.get("v.shopSuppliePercent");
        var totalShopSupplies;
        if(shopSuppliescap > 0.00 && !isNaN(totalLabor)){
            totalShopSupplies = (totalLabor/100) * shopSuppliesPer <= shopSuppliescap ? (totalLabor/100) * shopSuppliesPer : shopSuppliescap;
        }
        else if(totalLabor > 0.00 && !isNaN(totalLabor)){
            totalShopSupplies = (totalLabor/100) * shopSuppliesPer;
        }

        var woJob = component.get("v.WOJ");
        var wojWithJLI = component.get("v.wojWithJLI");
        if(typeof wojWithJLI != "undefined"){
                var salestaxConfig = wojWithJLI.salesTaxConfig;
            
                if(typeof woJob != "undefined" && typeof wojWithJLI.salesTaxConfig != "undefined" && typeof storeLocation != "undefined" && salestaxConfig[storeLocation] != "undefined" && woJob.BOATBUILDING__Taxable__c == true){
                    
                    console.log('sales tax config---', salestaxConfig);
                    var jobTotal = 0.00;
                    var salestaxconfigObject = salestaxConfig[storeLocation];
                    if(typeof salestaxconfigObject != "undefined"){

                
                    var salestaxPercent = salestaxconfigObject.BOATBUILDING__Regular_Sales_Tax__c;
                    var isPartTaxable = salestaxconfigObject.BOATBUILDING__Part_Tax__c;
                    var isMiscTaxable = salestaxconfigObject.BOATBUILDING__Misc_Tax__c;
                    var islaborTaxable = salestaxconfigObject.BOATBUILDING__Labor_Tax__c;
                    var isShopSuppliesTaxable = salestaxconfigObject.BOATBUILDING__Shop_Supplies_Tax__c;
                    if(isPartTaxable == true && typeof totalparts !="undefined" && !isNaN(totalparts)){
                        jobTotal = parseFloat(jobTotal) + parseFloat(totalparts);
                        
                    }
                    if(isShopSuppliesTaxable == true && component.get("v.recordType") != "Warranty Work Order"){
                        if(typeof totalShopSupplies !="undefined" && !isNaN(totalShopSupplies))
                        jobTotal = parseFloat(jobTotal) + parseFloat(totalShopSupplies);
                        
                    }
                    if(islaborTaxable == true){
                        if(typeof totalLabor != "undefined" && !isNaN(totalLabor))
                        jobTotal = parseFloat(jobTotal) + parseFloat(totalLabor);
                        
                    }
                    if(isMiscTaxable == true){
                        console.log('total MISC'+totalMisc);
                        if(typeof totalMisc != "undefined" && !isNaN(totalMisc))
                        jobTotal = parseFloat(jobTotal) + parseFloat(totalMisc);
                    }
                    var totalDiscountOnWorkOrderJobs = 0.00;
                    if(typeof woJob.BOATBUILDING__Discount__c != "undefined"){
                        totalDiscountOnWorkOrderJobs =  parseFloat(woJob.BOATBUILDING__Discount__c);
                        if(typeof totalDiscountOnWorkOrderJobs !="undefined" && !isNaN(totalDiscountOnWorkOrderJobs))
                        jobTotal = parseFloat(jobTotal) - totalDiscountOnWorkOrderJobs;
                    }
                    console.log('salestaxPercent'+salestaxPercent);
                    console.log('jobTotalAfterSalestax',jobTotal);
                    var totalTax = (parseFloat(jobTotal)/100) * parseFloat(salestaxPercent);
                    console.log('total tax'+totalTax);
                    
                    var jobTotalWithoutTax = component.get("v.jobTotal"); 
                    console.log(isNaN(jobTotalWithoutTax));
                    console.log(isNaN(totalTax));
                    console.log('jobTotalWithoutTax', component.get("v.jobTotal"));
                    if(!isNaN(jobTotalWithoutTax) && !isNaN(totalTax) && component.get("v.WOJ.BOATBUILDING__Taxable__c") == true){
                        var jobTotalWithTax = parseFloat(jobTotalWithoutTax) + totalTax; 
                        console.log('jobTotalWithTax inside', jobTotalWithTax);
                        var ShippingCharges = isNaN(component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c")) ? 0.00 : component.get("v.WOJ.BOATBUILDING__Shipping_Charge__c");
                        console.log('Shippinghcarges',ShippingCharges);
                        console.log('wojjjjjjjj',woJob);
                        if(typeof ShippingCharges !="undefined" && !isNaN(ShippingCharges)){
                            jobTotalWithTax = parseFloat(jobTotalWithTax) + parseFloat(ShippingCharges);
                        }
                        console.log('jobTotalWithTax after shipping', jobTotalWithTax);
                        console.log('code came here');
                        component.set("v.jobTotalwTax", jobTotalWithTax.toFixed(2));
                        component.set("v.taxOnJob", totalTax.toFixed(2));
                        component.set("v.WOJ.jobTotalwTax",jobTotalWithTax.toFixed(2));
                        component.set("v.WOJ.taxOnJob",totalTax.toFixed(2));
                    }
                }
            }
            else{
                component.set("v.WOJ.jobTotalwTax",0.00);
                component.set("v.WOJ.taxOnJob",0.00);
            }
        }
        
        
        this.hideSpinner(component,event,helper);

    },

    saveJobWithJLI : function(component, event, helper){
        console.log('saveJobFromJobCMP',JSON.parse(JSON.stringify(component.get("v.WOJ"))));
        var objWOJ = component.get("v.WOJ");
        var woObject = new Object();
        if(typeof objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != "undefined"){
            woObject.workOrderId = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
        }
        if(typeof objWOJ.Id != "undefined"){
            woObject.Id = objWOJ.Id;
        }
        if(typeof objWOJ.BOATBUILDING__Technician__c != "undefined"){
            woObject.technicianId = objWOJ.BOATBUILDING__Technician__c;
        }
        if(typeof objWOJ.BOATBUILDING__Approved_By_Customer__c != "undefined"){
            woObject.isApprovedByCustomer = objWOJ.BOATBUILDING__Approved_By_Customer__c;
        }
        if(typeof objWOJ.BOATBUILDING__Taxable__c != "undefined"){
            woObject.isJobTaxable = objWOJ.BOATBUILDING__Taxable__c;
        }
        if(typeof objWOJ.BOATBUILDING__Discount__c != "undefined"){
            woObject.discontOnJob = objWOJ.BOATBUILDING__Discount__c;
        }
        if(typeof objWOJ.BOATBUILDING__Shipping_Charge__c != "undefined"){
            woObject.ShippingCharges = objWOJ.BOATBUILDING__Shipping_Charge__c;
        }
        if(typeof objWOJ.Name != "undefined"){
            woObject.Name = objWOJ.Name;
        }
        if(typeof objWOJ.BOATBUILDING__Job_Name__c != "undefined"){
            woObject.jobName = objWOJ.BOATBUILDING__Job_Name__c;
        }
        if(typeof objWOJ.BOATBUILDING__Work_Type__c != "undefined"){
            woObject.WorkType = objWOJ.BOATBUILDING__Work_Type__c;
        }
        if(typeof objWOJ.BOATBUILDING__No_of_Labors__c != "undefined"){
            woObject.numberOfLabor = objWOJ.BOATBUILDING__No_of_Labors__c;
        }
        if(typeof objWOJ.BOATBUILDING__Total_Amount_Job__c != "undefined"){
            woObject.totalAmountOnJob = objWOJ.BOATBUILDING__Total_Amount_Job__c;
        }
        if(typeof objWOJ.BOATBUILDING__Shop_Supplies_Total__c != "undefined"){
            woObject.shopSupplies = objWOJ.BOATBUILDING__Shop_Supplies_Total__c;
        }
        if(typeof objWOJ.taxOnJob != "undefined"){
            woObject.taxOnJob = objWOJ.taxOnJob;
        }
        if(typeof objWOJ.laborPriceMultiplier != "undefined"){
            woObject.laborMuliplier = objWOJ.laborPriceMultiplier;
        }
        if(typeof objWOJ.jobTotalwTax != "undefined"){
            woObject.jobTotalwTax = objWOJ.jobTotalwTax;
        }
       
        if(typeof objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r != "undefined" ){
            if(typeof objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.Name != "undefined"){
                woObject.RecordTypeName = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.Name;
            }
            
        }else{
            woObject.RecordTypeName = component.get("v.recordType");
        }
        if(component.get("v.recordType") == "Warranty Work Order"){
            if(typeof objWOJ.BOATBUILDING__Claim_Status_New__c != "undefined"){
                woObject.claimStatus = objWOJ.BOATBUILDING__Claim_Status_New__c;
            }
            if(typeof objWOJ.BOATBUILDING__Claim_Approval_Date__c != "undefined"){
                woObject.claimApprovalDate = objWOJ.BOATBUILDING__Claim_Approval_Date__c;
            }
            if(typeof objWOJ.BOATBUILDING__Claim_Date__c != "undefined"){
                woObject.claimDate = objWOJ.BOATBUILDING__Claim_Date__c;
            }
            if(typeof objWOJ.BOATBUILDING__Claim_Paid_Date__c != "undefined"){
                woObject.claimPaidDate = objWOJ.BOATBUILDING__Claim_Paid_Date__c;
            }
            if(typeof objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c != "undefined"){
                woObject.claimLaborPaidAmount = objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c;
            }
            if(typeof objWOJ.BOATBUILDING__Parts_Paid_Amount__c != "undefined"){
                woObject.claimPartsPaidAmount = objWOJ.BOATBUILDING__Parts_Paid_Amount__c;
            }
            if(typeof objWOJ.BOATBUILDING__Misc_Charge_Paid__c != "undefined"){
                woObject.claimMiscChargesPaid = objWOJ.BOATBUILDING__Misc_Charge_Paid__c;
            }
            if(typeof objWOJ.BOATBUILDING__Claim_Labor_Approved_Amount__c != "undefined"){
                woObject.claimLaborApprovedAmount = objWOJ.BOATBUILDING__Claim_Labor_Approved_Amount__c;
            }
            if(typeof objWOJ.BOATBUILDING__Return_Parts_Amount__c != "undefined"){
                woObject.claimReturnPartsAmount = objWOJ.BOATBUILDING__Return_Parts_Amount__c;
            }
            if(typeof objWOJ.BOATBUILDING__Total_Paid__c != "undefined"){
                woObject.claimTotalPaidAmount = objWOJ.BOATBUILDING__Total_Paid__c;
            }
               
        }
        if(typeof objWOJ.partsTotal != "undefined"){
            woObject.PartsTotal = objWOJ.partsTotal;
        }
        if(typeof objWOJ.BOATBUILDING__Misc_Description_1__c != "undefined"){
            woObject.miscDesc1 = objWOJ.BOATBUILDING__Misc_Description_1__c;
        }
        if(typeof objWOJ.BOATBUILDING__Misc_Charge__c != "undefined"){
            woObject.miscCharge1 = objWOJ.BOATBUILDING__Misc_Charge__c;
            
        }
        if(typeof objWOJ.BOATBUILDING__Misc_Description_2__c != "undefined"){
            woObject.miscDesc2 = objWOJ.BOATBUILDING__Misc_Description_2__c;
        }
        if(typeof objWOJ.BOATBUILDING__Misc_Charge_2__c != "undefined"){
            woObject.miscCharge2 = objWOJ.BOATBUILDING__Misc_Charge_2__c;
        }
        if(typeof objWOJ.BOATBUILDING__Misc_Description_3__c != "undefined"){
            woObject.miscDesc3 = objWOJ.BOATBUILDING__Misc_Description_3__c;
        }
        if(typeof objWOJ.BOATBUILDING__Misc_Charge_3__c != "undefined"){
            woObject.miscCharge3 = objWOJ.BOATBUILDING__Misc_Charge_3__c;
        }
        if(typeof objWOJ.BOATBUILDING__Customer_Comments__c != "undefined"){
            woObject.customerComment = objWOJ.BOATBUILDING__Customer_Comments__c;
        }
        if(typeof objWOJ.BOATBUILDING__Comments__c != "undefined"){
            woObject.serviceWriterComment = objWOJ.BOATBUILDING__Comments__c;
        }
       
        if(typeof objWOJ.BOATBUILDING__Work_Order_Job_Line_Items__r != "undefined"){
            var lstJobLineItems = [];
            for(var i = 0 ; i < objWOJ.BOATBUILDING__Work_Order_Job_Line_Items__r.length; i++){
                var lineItem = new Object();
                var currentLI = objWOJ.BOATBUILDING__Work_Order_Job_Line_Items__r[i];
                if(typeof currentLI.Id != "undefined"){
                    lineItem.lineItemId = currentLI.Id;
                }
                if(typeof currentLI.BOATBUILDING__Related_to_Job__c != "undefined"){
                    lineItem.parentJob = currentLI.BOATBUILDING__Related_to_Job__c;
                }
                if(typeof currentLI.BOATBUILDING__Price__c != "undefined"){
                    lineItem.retailPrice = currentLI.BOATBUILDING__Price__c
                }
                if(typeof currentLI.BOATBUILDING__Quantity__c != "undefined"){
                    lineItem.qunatity = currentLI.BOATBUILDING__Quantity__c
                }
                if(typeof currentLI.BOATBUILDING__Dealer_Price__c != "undefined"){
                    lineItem.cost = currentLI.BOATBUILDING__Dealer_Price__c
                }
                if(typeof currentLI.BOATBUILDING__Part_Number__c != "undefined"){
                    lineItem.partNumber = currentLI.BOATBUILDING__Part_Number__c
                }
                 if(typeof currentLI.BOATBUILDING__Part_Name__c != "undefined"){
                    lineItem.partName = currentLI.BOATBUILDING__Part_Name__c;
                 }
                
                if(typeof currentLI.BOATBUILDING__Part__c != "undefined"){
                    lineItem.partId = currentLI.BOATBUILDING__Part__c
                }
                if(typeof currentLI.BOATBUILDING__Select_Part__c != "undefined"){
                    lineItem.inventoryId = currentLI.BOATBUILDING__Select_Part__c
                }
                lstJobLineItems.push(lineItem);
            }
            woObject.lstJobLineItems = lstJobLineItems;
        }

        //console.log('finalDataforsavingrecords',woObject);
        //console.log('finalDataforsavingrecords',JSON.stringify(woObject));
        component.set('v.WOJ.finalJobData',woObject);
      
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