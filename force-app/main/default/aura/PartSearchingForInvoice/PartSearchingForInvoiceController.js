({  
    doInit : function(component, event, helper) {
    component.set("v.objInv.SortingOrder",component.get("v.SortingOrder"))
    console.log('BNMNMM'+component.get("v.objInv.SortingOrder"));
    },
	handleKeyUp: function (cmp, evt, helper) {
        var isEnterKey = evt.keyCode === 13;
            cmp.set("v.isSearchLoading", true);
            var queryTerm = cmp.find('enter-search').get('v.value');
            cmp.set("v.objInv.PartName",cmp.find('enter-search').get('v.value'));
            if(queryTerm.length > 3){
                var isMisc = cmp.get("v.objInv.isMISC");
                if(isMisc == false){
                    helper.searchParts(cmp, evt, helper);
                }
                else{
                    cmp.set("v.isSearchLoading", false);
                }
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
            else{
                cmp.set("v.isSearchLoading", false);
            }
        
    },
    onBlur : function(component, event, helper){
        
        
      //  component.set("v.searchResults", []);
       // component.set("v.objInv.PartName",component.find('enter-search').get('v.value'));
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
            component.set("v.isSearchLoading", false);
                console.log('searchResult',JSON.parse(response.getReturnValue()));
                component.set("v.searchResults", JSON.parse(response.getReturnValue()));
        });
        var isMisc = component.get("v.objInv.isMISC");
                if(isMisc == false){
                    component.set("v.isSearchLoading", true);
            $A.enqueueAction(searchAction); 
        }  
        else{
            component.set("v.isSearchLoading", false);
        }
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
                
                objPOLI.QuantityDec = 0;
                objPOLI.discount = 0; 
                objPOLI.discountPer = 0.00;
                objPOLI.TotalWithoutDisc = 0.00;
                objPOLI.discount = 0.00;
                objPOLI.isDisabled = false;
                objPOLI.isMISC= false;
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
        console.log("value", value);
        for(var i = 0; i < searchResultArray.length; i++){

            if(searchResultArray[i].PartId == value ){
                console.log('searchResultArraysearchResultArraysearchResultArraysearchResultArray',searchResultArray[i]);
                component.set("v.objInv.PartName",searchResultArray[i].PartName); 
                component.set("v.objInv.PartNumber",searchResultArray[i].PartNumber);
                component.set("v.objInv.PartId",searchResultArray[i].PartId);
                component.set("v.objInv.QuantityDec",searchResultArray[i].QuantityDec);
                component.set("v.objInv.isDisabled", true);
                component.set("v.objInv.isMISC", false);

                component.set("v.objInv.Cost", searchResultArray[i].Cost);
                component.set("v.objInv.partMSRP", searchResultArray[i].partMSRP);
                if(typeof searchResultArray[i].QuantityDec != "undefined" && typeof searchResultArray[i].partMSRP != "undefined");
                var total = parseInt(searchResultArray[i].QuantityDec) * parseFloat(searchResultArray[i].partMSRP);
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
        objPOLI.QuantityDec = 0; 
        objPOLI.Cost = 0.00;
        objPOLI.discountPer = 0.00;
        objPOLI.discount = 0.00;
        objPOLI.partMSRP = 0.00;
        objPOLI.TotalWithoutDisc = 0.00;
        objPOLI.Total = 0.00;
        component.set("v.objInv", objPOLI); 
        component.set("v.showPill", false);
    },
    checkQuantity : function(component, event, helper)  {
        var objInvoice = component.get("v.objInv");
        console.log('>>>>>on load objInvoice::',objInvoice);
        if(objInvoice.QuantityDec < 0 ){
            objInvoice.discountPer = 0;
            objInvoice.discount = 0.00;
            component.set("v.fieldDisable",true);
        }else{
            component.set("v.fieldDisable",false);
        }
    },
    updateTotal : function(component, event, helper) {
        var objInvoice = component.get("v.objInv");
        if(objInvoice.PartNumber == '' && (objInvoice.PartName == null || objInvoice.PartName == '' )){
            objInvoice.PartName = component.find('enter-search').get('v.value');
        }
        objInvoice.Total = objInvoice.partMSRP * objInvoice.QuantityDec ;
        if(objInvoice.QuantityDec < 0 ){
            objInvoice.discountPer = 0;
            objInvoice.discount = 0.00;
            component.set("v.fieldDisable",true);
        }else{
            component.set("v.fieldDisable",false);
        }
        console.log('objInvoice.partMSRP',objInvoice.partMSRP);
        if(objInvoice.partMSRP == 0 || objInvoice.partMSRP == '' || objInvoice.partMSRP == null || objInvoice.partMSRP == '0'){
            objInvoice.discountPer = 0;
            objInvoice.discount = 0.00;
            
        }else{
            console.log('objInvoice.partMSRP ',objInvoice.partMSRP );
            
        }
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
     if(objInvoice.discountPer >= 0 ){
         
        objInvoice.discount = (objInvoice.partMSRP * objInvoice.QuantityDec * objInvoice.discountPer/100).toFixed(2);
        objInvoice.Total =((objInvoice.partMSRP * objInvoice.QuantityDec) - objInvoice.discount).toFixed(2) ;    
        component.set("v.objInv", objInvoice);
        component.set("v.objInv.Total", objInvoice.Total);
        var inputField = component.find('disPer');
       
        inputField.setCustomValidity('');
        inputField.reportValidity();
        var inputField = component.find('disdollar');
        
        inputField.setCustomValidity('');
        inputField.reportValidity();
     }else{
        var inputField = component.find('disPer');
       
        inputField.setCustomValidity('Negetive values are not allowed');
        inputField.reportValidity();
     }
     

   },
   disCalculationInDollar : function(component, event, helper) {
    var objInvoice = component.get("v.objInv");
    if(objInvoice.discount >= 0 ){
        objInvoice.discountPer = ((objInvoice.discount * 100)/(objInvoice.partMSRP * objInvoice.QuantityDec)).toFixed(2);
        objInvoice.Total =((objInvoice.partMSRP * objInvoice.QuantityDec) - objInvoice.discount).toFixed(2) ;
        component.set("v.objInv", objInvoice);
        component.set("v.objInv.Total", objInvoice.Total);
        var inputField = component.find('disdollar');
        
        inputField.setCustomValidity('');
        inputField.reportValidity();

        var inputField = component.find('disPer');
       
        inputField.setCustomValidity('');
        inputField.reportValidity();
    }else{
        var inputField = component.find('disdollar');
        
        inputField.setCustomValidity('Negetive values are not allowed');
        inputField.reportValidity();
    }
    

    
    
  }
   
    
})