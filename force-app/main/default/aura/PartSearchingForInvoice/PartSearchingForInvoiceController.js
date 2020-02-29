({  
    
	handleKeyUp: function (cmp, evt, helper) {
        var isEnterKey = evt.keyCode === 13;
            cmp.set("v.isSearchLoading", true);
            var queryTerm = cmp.find('enter-search').get('v.value');
            if(queryTerm.length > 3){
                helper.searchParts(cmp, evt, helper);
                var results = [];

                var result1 = {};
                result1.text = 'Ajay';
                result1.val='123';
        
                var result2 = {};
                result2.text = 'Sajal';
                result2.val='456';
                results.push(result1);
                results.push(result2);
                //cmp.set("v.searchResults", results);  
            }
        
    },
    handlonfocus : function (component, event, helper) {
        var searchAction = component.get("c.searchPartsfromInventoryAndParts");
        var queryTerm = 'recentlyViewed';
        console.log('querytermmmmmmmmmmm');
        searchAction.setParams({
            "searchStr" : queryTerm
        });
        searchAction.setCallback(this, function(response){
            component.set("v.isSearchLoading", false);
                console.log('searchResult',JSON.parse(response.getReturnValue()));
                component.set("v.searchResults", JSON.parse(response.getReturnValue()));
        });

        $A.enqueueAction(searchAction);   
    },
   
    selectValue : function(component, event, helper) { 
        var prtList = component.get("v.searchResults"); 
        var objPOLI = component.get("v.objInv");
        var index = event.currentTarget.id;
        for(var i = 0; i < prtList.length; i++) {
            if(index == prtList[i].partId) {
                objPOLI.PartId = '';
                objPOLI.PartName = prtList[i].partName;
                objPOLI.PartNumber = prtList[i].partNumber;
                
                objPOLI.Quantity = 0;
                objPOLI.discount = 0; 
                objPOLI.discountPer = 0.00;
                objPOLI.TotalWithoutDisc = 0.00;
                objPOLI.discount = 0.00;
                objPOLI.Cost = prtList[i].partCost;
                objPOLI.partMSRP = prtList[i].partMSRP;
                objPOLI.Total = 0.00;
                component.set("v.objInv", objPOLI);
                
            }
        }
        component.set("v.searchResults", []);
        component.set("v.showPill", true);
    },
    itemSelected : function(component, event, helper){
        var label = event.currentTarget.dataset.label;
        var value = event.currentTarget.dataset.value;
        component.set("v.selectedRecord",label);
        component.set("v.showPill", true);
        component.set("v.selectedRecordId",value);
        //component.set("v.objInv.PartNumber",label);
        var searchResultArray = component.get("v.searchResults");
        console.log('searchResultArray',searchResultArray);
        for(var i = 0; i < searchResultArray.length; i++){

            if(searchResultArray[i].PartId == value ){
                console.log('searchResultArraysearchResultArraysearchResultArraysearchResultArray',searchResultArray[i]);
                component.set("v.objInv.PartName",searchResultArray[i].PartName); 
                component.set("v.objInv.PartNumber",searchResultArray[i].PartNumber);
                component.set("v.objInv.PartId",searchResultArray[i].PartId);
                component.set("v.objInv.Quantity",searchResultArray[i].quantity);
                component.set("v.objInv.Cost", searchResultArray[i].Cost);
                component.set("v.objInv.partMSRP", searchResultArray[i].partMSRP);
                if(typeof searchResultArray[i].quantity != "undefined" && typeof searchResultArray[i].partMSRP != "undefined");
                var total = parseInt(searchResultArray[i].quantity) * parseFloat(searchResultArray[i].partMSRP);
                if(typeof total != "undefined" && !isNaN(total))
                component.set("v.objInv.Total",total);
                break;
            }
           




        }


    },
    removePart: function(component, event, helper) {
        var objPOLI = component.get("v.objInv");
        objPOLI.PartId = ''; 
        objPOLI.PartName = ''; 
        objPOLI.PartNumber = '';
        objPOLI.Quantity = 0; 
        objPOLI.Cost = 0.00;
        objPOLI.discountPer = 0.00;
        objPOLI.discount = 0.00;
        objPOLI.partMSRP = 0.00;
        objPOLI.TotalWithoutDisc = 0.00;
        objPOLI.Total = 0.00;
        component.set("v.objInv", objPOLI); 
        component.set("v.showPill", false);
    },
    updateTotal : function(component, event, helper) {
        var objInvoice = component.get("v.objInv");
        objInvoice.Total = objInvoice.partMSRP * objInvoice.Quantity ;
        component.set("v.objInv", objInvoice);
    },
    show : function(component, event, helper) {
        component.set("v.dis", false);
    },
    pillRemoved : function(component, event, helper){
        component.set("v.selectedRecordId",'');
       component.set("v.selectedRecord",'');
       component.set("v.showPill", false);
       component.set("v.searchResults", []);  
    },
    fireInvoiceTotalEvent : function(component, event, helper) {
        var appEvent = $A.get("e.c:CalculateInvoice");
        appEvent.fire();

    },
   discountCalculation : function(component, event, helper) {
     var objInvoice = component.get("v.objInv");
     objInvoice.discount = (objInvoice.partMSRP * objInvoice.Quantity * objInvoice.discountPer/100).toFixed(2);
     objInvoice.Total =((objInvoice.partMSRP * objInvoice.Quantity) - objInvoice.discount).toFixed(2) ;    
     component.set("v.objInv", objInvoice);
     component.set("v.objInv.Total", objInvoice.Total);

   },
   disCalculationInDollar : function(component, event, helper) {
    var objInvoice = component.get("v.objInv");
    objInvoice.discountPer = ((objInvoice.discount * 100)/(objInvoice.partMSRP * objInvoice.Quantity)).toFixed(2);
    objInvoice.Total =((objInvoice.partMSRP * objInvoice.Quantity) - objInvoice.discount).toFixed(2) ;
    component.set("v.objInv", objInvoice);
    component.set("v.objInv.Total", objInvoice.Total);
  }
   
    
})