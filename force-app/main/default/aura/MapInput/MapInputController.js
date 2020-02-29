({
    getCities : function(component, event, helper){	
        
        var params = {
            "input" : component.get('v.location')	
        } 
        
        helper.callServer(component,"c.getSuggestions",function(response){
            var resp = JSON.parse(response);	
            console.log(resp.predictions);
            component.set('v.predictions',resp.predictions);	
        },params);	
        
    },
    
    getCityDetails : function(component, event, helper){		 
        
        var selectedItem = event.currentTarget;
        var placeid = selectedItem.dataset.placeid;
        
        var params = {
            "placeId" : placeid  	
        } 
        
        helper.callServer(component,"c.getPlaceDetails",function(response){
            var placeDetails = JSON.parse(response); 		 
            console.log('placeDetails');
            console.log(placeDetails.result.formatted_address);
            component.set('v.location', placeDetails.result.name);	 
            var formatedAdd = placeDetails.result.formatted_address;
            console.log('BFR');
            var formatedAddSp = formatedAdd.split(',');
            console.log('AFTR');
            var zip = '';
            var city = '';
            var add = '';
            var state = '';
            console.log('trav');
            for(var i = formatedAddSp.length-1; i >= 0; i--) {
                console.log(formatedAddSp[i]);
                if(formatedAddSp.length - 2 == i) {
                    var zipp = formatedAddSp[i].split(' ');
                    if(zipp.length > 1) {
                        zip = zipp[zipp.length - 1];
                        state = zipp[zipp.length - 2];
                    }
                }else if(formatedAddSp.length - 3 == i) {
                    city = formatedAddSp[i];
                }
                else if(i < formatedAddSp.length - 2) {
                    if(add == '') {
                        add = formatedAddSp[i];
                    } else {
                        add = formatedAddSp[i] + ', ' +  add;    
                    }   
                }
                
                
            }
            console.log('zip');
            console.log(zip);
            console.log(city);
            console.log(add);
              
            var objAcc = component.get("v.objAccountMP");
            objAcc.BillingStreet = add;
            objAcc.BillingCity = city;
            objAcc.BillingState = state;
            objAcc.BillingPostalCode = zip;            
            
            component.set('v.predictions',[]); 
            var cmpEvent = $A.get("e.c:AccountParentToChild");
            
            cmpEvent.setParams({ 
                "objAccount": objAcc,
                "tab": "Map"
            });
            cmpEvent.fire();
        },params);	
        
    }
})