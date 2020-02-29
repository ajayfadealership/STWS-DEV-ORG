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
    doInit : function(component, event, helper){
       var jliObject = component.get("v.JLI");
       if(jliObject.Id != '' && jliObject.Id != undefined && jliObject.Id != 'undefined'){
        component.set("v.selectedRecord",jliObject.BOATBUILDING__Part_Name__c+'--'+jliObject.BOATBUILDING__Part_Number__c);
        component.set("v.showPill", true);
        component.set("v.selectedRecordId",jliObject.Id);
       }
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
            if(searchResultArray[i].partId == value){
                console.log('selectedparts',searchResultArray[i]);
                component.set("v.JLI.BOATBUILDING__Quantity__c",searchResultArray[i].quantity); 
                component.set("v.JLI.BOATBUILDING__Price__c",searchResultArray[i].partMSRP); 
                component.set("v.JLI.BOATBUILDING__Dealer_Price__c",searchResultArray[i].partCost); 
                component.set("v.JLI.BOATBUILDING__Part_Name__c", searchResultArray[i].partName)
                component.set("v.JLI.BOATBUILDING__Part_Number__c", searchResultArray[i].partNumber)

                if(searchResultArray[i].isInventoryPart == true){
                    component.set("v.JLI.BOATBUILDING__Select_Part__c",searchResultArray[i].partId); 
                }else{
                    component.set("v.JLI.BOATBUILDING__Part__c",searchResultArray[i].partId); 
                }   
                break;
            }
           
       }

       
    },
    pillRemoved : function(component, event, helper){
        component.set("v.selectedRecordId",'');
       component.set("v.selectedRecord",'');
       component.set("v.showPill", false);
       component.set("v.searchResults", []);  
       component.set("v.JLI.BOATBUILDING__Quantity__c", 0); 
       component.set("v.JLI.BOATBUILDING__Price__c",0.00); 
       component.set("v.JLI.BOATBUILDING__Dealer_Price__c",0.00); 
       component.set("v.JLI.BOATBUILDING__Part_Name__c", '');
       component.set("v.JLI.BOATBUILDING__Part_Number__c", '');
       component.set("v.JLI.BOATBUILDING__Select_Part__c",''); 
       component.set("v.JLI.BOATBUILDING__Part__c",''); 
       
    },
    lineItemUpdated : function(component, event, helper){
        var compEvent = $A.get("e.c:JobLineItemUpdated");
        
        
        compEvent.fire();
        
    }
})