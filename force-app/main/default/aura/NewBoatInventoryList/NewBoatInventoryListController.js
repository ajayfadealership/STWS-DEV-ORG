({
    doInit : function(component, event, helper) {

        helper.getAllInventories(component, event, helper);
    },
    resetCount : function(component, event, helper){  
        console.log('local data changed');      
        component.set("v.spinner", true); 
       var dataSet =  component.get("v.fetchDataLocal");
       var storeLocationMap = new Map();
       var statusMap = new Map();
       var typeMap = new Map(); 
       var recordTypeMap = new Map();
       var yearMap = new Map();
       var makeMap = new Map();
       var modelMap = new Map();
       var boatTypeMap = new Map();
       for(var i = 0; i < dataSet.length; i++){
        if(typeof dataSet[i].BOATBUILDING__Stage__c != "undefined"){
            if(statusMap.has(dataSet[i].BOATBUILDING__Stage__c)){
                var statusCount = parseInt(statusMap.get(dataSet[i].BOATBUILDING__Stage__c));
                statusCount = statusCount + 1;
                statusMap.set(dataSet[i].BOATBUILDING__Stage__c, statusCount);
            }else{
                
                statusMap.set(dataSet[i].BOATBUILDING__Stage__c, 1);
            }
        }
        if(typeof dataSet[i].BOATBUILDING__Store_Location__c != "undefined"){
            if(storeLocationMap.has(dataSet[i].BOATBUILDING__Store_Location__c)){
                var stLCount = parseInt(storeLocationMap.get(dataSet[i].BOATBUILDING__Store_Location__c));
                stLCount = stLCount + 1;
                storeLocationMap.set(dataSet[i].BOATBUILDING__Store_Location__c, stLCount);
            }else{
                
                storeLocationMap.set(dataSet[i].BOATBUILDING__Store_Location__c, 1);
            }
        }
            if(recordTypeMap.has(dataSet[i].RecordType.Name)){
                var rtCount = parseInt(recordTypeMap.get(dataSet[i].RecordType.Name));
                rtCount = rtCount + 1;
                recordTypeMap.set(dataSet[i].RecordType.Name, rtCount);
            }else{
                recordTypeMap.set(dataSet[i].RecordType.Name, 1);
            }   
            if(typeof dataSet[i].BOATBUILDING__Year__c != "undefined"){
                if(yearMap.has(dataSet[i].BOATBUILDING__Year__c)){
                    var yearCount = parseInt(yearMap.get(dataSet[i].BOATBUILDING__Year__c));
                    yearCount = yearCount + 1;
                    yearMap.set(dataSet[i].BOATBUILDING__Year__c, yearCount);
                }else{
                    
                    yearMap.set(dataSet[i].BOATBUILDING__Year__c, 1);
                }
            }
            if(typeof dataSet[i].BOATBUILDING__Manufacturer__c != "undefined"){
                if(makeMap.has(dataSet[i].BOATBUILDING__Manufacturer__c)){
                    var makeCount = parseInt(makeMap.get(dataSet[i].BOATBUILDING__Manufacturer__c));
                    makeCount = makeCount + 1;
                    makeMap.set(dataSet[i].BOATBUILDING__Manufacturer__c, makeCount);
                }else{
                    
                    makeMap.set(dataSet[i].BOATBUILDING__Manufacturer__c, 1);
                }
            }
            if(typeof dataSet[i].BOATBUILDING__Model__c != "undefined"){
                if(modelMap.has(dataSet[i].BOATBUILDING__Model__c)){
                    var modelCount = parseInt(modelMap.get(dataSet[i].BOATBUILDING__Model__c));
                    modelCount = modelCount + 1;
                    modelMap.set(dataSet[i].BOATBUILDING__Model__c, modelCount);
                }else{
                    
                    modelMap.set(dataSet[i].BOATBUILDING__Model__c, 1);
                }
            }
            
            if(typeof dataSet[i].BOATBUILDING__Boat_Type__c != "undefined"){
                if(boatTypeMap.has(dataSet[i].BOATBUILDING__Boat_Type__c)){
                    var bTypeCount = parseInt(boatTypeMap.get(dataSet[i].BOATBUILDING__Boat_Type__c));
                    bTypeCount = bTypeCount + 1;
                    boatTypeMap.set(dataSet[i].BOATBUILDING__Boat_Type__c, bTypeCount);
                }else{
                    boatTypeMap.set(dataSet[i].BOATBUILDING__Boat_Type__c, 1);
                }
            }
            
            
       }
       var changedField = component.get("v.filterChangedFieldName");
       if(changedField == 'load' || changedField == 'search'){
                
                var rtMap = [];
                for (const [key, value] of recordTypeMap.entries()) {
                    console.log(key, value);
                    rtMap.push({key: key, value: value});
                }
                component.set("v.recordTypeMap",rtMap); 
                component.set("v.type", 'All'); 
        }
        if(changedField == 'Type' || changedField == 'load' || changedField == 'search'){
            var stageMap = [];
            for (const [key, value] of statusMap.entries()) {
            console.log(key, value);
            stageMap.push({key: key, value: value});
            }
            component.set("v.statusMap",stageMap);  
            component.set("v.status", 'All'); 
        }
        if(changedField == 'Type' || changedField == 'Status' || changedField == 'load' || changedField == 'search'){
            var ymap = [];
            for (const [key, value] of yearMap.entries()) {
                console.log(key, value);
                ymap.push({key: key, value: value});
            }
            component.set("v.yearMap", ymap); 
            component.set("v.Year", 'All'); 
        }
        if(changedField == 'Type' || changedField == 'Status' || changedField == 'Year' || changedField == 'load' || changedField == 'search'){
            var btMap = [];
            for (const [key, value] of boatTypeMap.entries()) {
            console.log(key, value);
                btMap.push({key: key, value: value});
            }
            component.set("v.boatTypeMap", btMap); 
            component.set("v.boatType", 'All'); 
        }
        if(changedField == 'Type' || changedField == 'Status' || changedField == 'Year' || changedField == 'BoatType' || changedField == 'load' || changedField == 'search'){
            var manufMap = [];
            for (const [key, value] of makeMap.entries()) {
            console.log(key, value);
            manufMap.push({key: key, value: value});
            }
            component.set("v.makeMap",manufMap); 
            component.set("v.Make", 'All'); 
        }
        if(changedField == 'Type' || changedField == 'Status' || changedField == 'Year' || changedField == 'BoatType' || changedField== 'Make' || changedField == 'load' || changedField == 'search'){
            var modelData = [];
            for (const [key, value] of modelMap.entries()) {
            console.log(key, value);
                modelData.push({key: key, value: value});
            }
            component.set("v.modelMap",modelData); 
            component.set("v.Model", 'All');  
        }


        console.log(modelData);
       
       
        if(changedField == 'Type' || changedField == 'Status' || changedField == 'Year' || changedField == 'BoatType' || changedField== 'Make' || changedField == 'Model' || changedField == 'load' || changedField == 'search'){
            var stMap = [];
            for (const [key, value] of storeLocationMap.entries()) {
                console.log(key, value);
                stMap.push({key: key, value: value});
            }
            component.set("v.StoreLocationMap",stMap); 
            component.set("v.storeLocaiton", 'All'); 
        }
     
       
        
       setTimeout(function(){ 
            component.set("v.spinner", false);
        }, 2000); 
       
    }, 

    typeChanged : function(component, event, helper){
        component.set("v.spinner", true);
        console.log(true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        
        for(var i = 0; i < reserveDataset.length; i++){
            if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
               
                    refinedLocalData.push(reserveDataset[i]);
              
            }
           
        }
        component.set("v.filterChangedFieldName", 'Type');
        component.set("v.fetchDataLocal",refinedLocalData);
        //component.set("v.spinner2", false);
    },
    statusChanged : function(component, event, helper){
        component.set("v.spinner", true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        var Status = component.get("v.status");
        console.log('typppppeee',type);
        console.log(Status);
        if(typeof reserveDataset != "undefined" && reserveDataset != null){
            for(var i = 0; i < reserveDataset.length; i++){
                if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
                    if(reserveDataset[i].BOATBUILDING__Stage__c == Status || Status == 'All' ){
                        refinedLocalData.push(reserveDataset[i]);
                    } 
                }
            }
            console.log('refinedLocalData',refinedLocalData);
            component.set("v.filterChangedFieldName", 'Status');
            component.set("v.fetchDataLocal",refinedLocalData);
            //component.set("v.spinner", false);
        }
        
    },
    yearChanged : function(component, event, helper){
        component.set("v.spinner", true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        var Status = component.get("v.status");
        var year = component.get("v.Year");
        for(var i = 0; i < reserveDataset.length; i++){
            if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
                if(reserveDataset[i].BOATBUILDING__Stage__c == Status || Status == 'All' ){
                    if(reserveDataset[i].BOATBUILDING__Year__c == year || year == 'All' ){
                        refinedLocalData.push(reserveDataset[i]);
                    }
                } 
            }
        }
        component.set("v.filterChangedFieldName", 'Year');
        component.set("v.fetchDataLocal",refinedLocalData);
        //component.set("v.spinner", false);
    },
    boatTypeChanged : function(component, event, helper){
        component.set("v.spinner", true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        var Status = component.get("v.status");
        var year = component.get("v.Year");
        var btype = component.get("v.boatType");
        for(var i = 0; i < reserveDataset.length; i++){
            if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
                if(reserveDataset[i].BOATBUILDING__Stage__c == Status || Status == 'All' ){
                    if(reserveDataset[i].BOATBUILDING__Year__c == year || year == 'All' ){
                        if(reserveDataset[i].BOATBUILDING__Boat_Type__c == btype || btype == 'All' ){
                            refinedLocalData.push(reserveDataset[i]);
                        }
                    }
                } 
            }
        }
        component.set("v.filterChangedFieldName", 'BoatType');
        
        component.set("v.fetchDataLocal",refinedLocalData);
        //component.set("v.spinner", false);
    },
    makeChanged : function(component, event, helper){
        component.set("v.spinner", true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        var Status = component.get("v.status");
        var year = component.get("v.Year");
        var btype = component.get("v.boatType");
        var make = component.get("v.Make");
        for(var i = 0; i < reserveDataset.length; i++){
            if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
                if(reserveDataset[i].BOATBUILDING__Stage__c == Status || Status == 'All' ){
                    if(reserveDataset[i].BOATBUILDING__Year__c == year || year == 'All' ){
                        if(reserveDataset[i].BOATBUILDING__Boat_Type__c == btype || btype == 'All' ){
                            if(reserveDataset[i].BOATBUILDING__Manufacturer__c == make || make == 'All' ){
                                refinedLocalData.push(reserveDataset[i]);
                            }
                        }
                    }
                } 
            }
        }
        component.set("v.filterChangedFieldName", 'Make');
        
        component.set("v.fetchDataLocal",refinedLocalData);
        //component.set("v.spinner", false);
    
    },
    modelChanged : function(component, event, helper){
        component.set("v.spinner", true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        var Status = component.get("v.status");
        var year = component.get("v.Year");
        var btype = component.get("v.boatType");
        var make = component.get("v.Make");
        var model = component.get("v.Model");
        for(var i = 0; i < reserveDataset.length; i++){
            if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
                if(reserveDataset[i].BOATBUILDING__Stage__c == Status || Status == 'All' ){
                    if(reserveDataset[i].BOATBUILDING__Year__c == year || year == 'All' ){
                        if(reserveDataset[i].BOATBUILDING__Boat_Type__c == btype || btype == 'All' ){
                            if(reserveDataset[i].BOATBUILDING__Manufacturer__c == make || make == 'All' ){
                                if(reserveDataset[i].BOATBUILDING__Model__c == model || model == 'All' ){
                                    refinedLocalData.push(reserveDataset[i]);
                                }
                            }
                        }
                    }
                } 
            }
        }
        component.set("v.filterChangedFieldName", 'Model');
        
        component.set("v.fetchDataLocal",refinedLocalData);
        //component.set("v.spinner", false);
    },
    storeLocationChanged : function(component, event, helper){
        component.set("v.spinner", true);
        var reserveDataset = component.get("v.fetchData");
        var refinedLocalData = [];
        var type = component.get("v.type");
        var Status = component.get("v.status");
        var year = component.get("v.Year");
        var btype = component.get("v.boatType");
        var make = component.get("v.Make");
        var model = component.get("v.Model");
        var storeLocation = component.get("v.storeLocaiton");
        for(var i = 0; i < reserveDataset.length; i++){
            if(reserveDataset[i].RecordType.Name == type || type == 'All' ){
                if(reserveDataset[i].BOATBUILDING__Stage__c == Status || Status == 'All' ){
                    if(reserveDataset[i].BOATBUILDING__Year__c == year || year == 'All' ){
                        if(reserveDataset[i].BOATBUILDING__Boat_Type__c == btype || btype == 'All' ){
                            if(reserveDataset[i].BOATBUILDING__Manufacturer__c == make || make == 'All' ){
                                if(reserveDataset[i].BOATBUILDING__Model__c == model || model == 'All' ){
                                    if(reserveDataset[i].BOATBUILDING__Store_Location__c == storeLocation || storeLocation == 'All' ){
                                        refinedLocalData.push(reserveDataset[i]);
                                    }
                                }
                            }
                        }
                    }
                } 
            }
        }
        component.set("v.filterChangedFieldName", 'StoreLocation');
        
        component.set("v.fetchDataLocal",refinedLocalData);
       // component.set("v.spinner", false);
    },
    handleKeyUp : function(component, event, helper){
        component.set("v.spinner", true);
     
            var queryTerm = component.find('enter-search').get('v.value');
            console.log(queryTerm);
            var reserveDataset = component.get("v.fetchData");
            if(queryTerm.length > 1){
                var refinedLocalData = [];
                queryTerm = queryTerm.toLowerCase();
                
                for(var i = 0; i < reserveDataset.length; i++){
                    var stringData = JSON.stringify(reserveDataset[i]);
                    stringData = stringData.toLowerCase();
                    if(stringData.search(queryTerm) != -1){
                        refinedLocalData.push(reserveDataset[i]);

                    }
                }
               // component.set("v.filterChangedFieldName", 'search');
                component.set("v.fetchDataLocal",refinedLocalData);
                console.log('search result',refinedLocalData);
                component.set("v.spinner", false);
            }
            else{
                component.set("v.filterChangedFieldName", 'load');
                component.set("v.fetchDataLocal",reserveDataset);
                //component.set("v.spinner", false);
            }
            
        
    },
    
    redirect : function(component, event, helper) {
        var recId =  event.target.getAttribute("title");
        window.open('/'+recId, '_Blank');
        // window.open('/'+recId, '_self');
    },
    navigate : function(component, event, helper) {
        var t = true;
        var id = event.target.getAttribute("data-recId");
        console.log(id);
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:BoatBuilderWizard",
            componentAttributes: {
                IventoryId : id
            }
        });
        navigateEvent.fire();
    }
})