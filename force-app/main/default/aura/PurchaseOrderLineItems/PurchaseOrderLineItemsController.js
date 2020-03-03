({
    searchPartKeyUp : function(component, event, helper) {
        var searchkeyword = component.find('searchPrtInp').get('v.value');
        if(searchkeyword.length > 2){
            helper.searchParts(component, event, helper);
        } else {
            component.set("v.searchResults", []);
        }
    },
    handlonfocus : function(component, event, helper) { 
        helper.searchPartsforRecent(component, event, helper); 
    },
    selectValue : function(component, event, helper) { 
        var prtList = component.get("v.searchResults"); 
        var objPOLI = component.get("v.objPOLI");
        var index = event.currentTarget.id;
        for(var i = 0; i < prtList.length; i++) {
            if(index == prtList[i].partId) {
                objPOLI.PartId = '';
                objPOLI.PartName = prtList[i].partName;
                objPOLI.PartNumber = prtList[i].partNumber;
                objPOLI.Quantity = 0;
                objPOLI.Cost = prtList[i].partCost;
                component.set("v.objPOLI", objPOLI); 
            }
        }
        component.set("v.searchResults", []);
        component.set("v.showPill", true);
    },
    removePart: function(component, event, helper) {
        var objPOLI = component.get("v.objPOLI");
        objPOLI.PartId = ''; 
        objPOLI.PartName = ''; 
        objPOLI.PartNumber = '';
        objPOLI.Quantity = 0; 
        objPOLI.Cost = 0.00;
        component.set("v.objPOLI", objPOLI); 
        component.set("v.showPill", false);
    },
    updateTotal : function(component, event, helper) {
        var objPOLI = component.get("v.objPOLI");
        component.set("v.lineItemTotal", objPOLI.Quantity * objPOLI.Cost);
    }
})