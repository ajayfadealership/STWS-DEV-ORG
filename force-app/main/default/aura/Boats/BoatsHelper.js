({  
    sortData: function (cmp, fieldName, sortDirection) {
        var result = cmp.get("v.Boat");
        var reverse = sortDirection !== 'asc';
        result.sort(this.sortBy(fieldName, reverse));
        cmp.set("v.Boat", result);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    viewCurrentRecord : function(component,recId){
        var action2 = component.get("c.getInventoryById");
        action2.setParams({
            "id" : recId
        });
        action2.setCallback(this ,function(response){          
            if(response.getState() === "SUCCESS"){
                // alert("test ")
                var result = response.getReturnValue();
                console.log('result',result);
                component.set("v.NameClicked",true); 
                var res = JSON.parse(response.getReturnValue()).results;
                console.log('res++++++== ',res);
                var str ="";
                for(var i=0;i<res[0].AdditionalDetailDescription.length;i++){
                    str +=res[0].AdditionalDetailDescription[i];
                }
                console.log('string ' ,str);
                res[0].AdditionalDetailDescription[0] = str;
                /*console.log('res++++++==GeneralBoatDescription ',res[0].GeneralBoatDescription[0]);
                var str = res[0].GeneralBoatDescription[0];
                console.log('str>>>: ',str);  
                str = str.replace(/(<([^>]+)>)/ig," ");
                res[0].GeneralBoatDescription[0] = str;
                console.log('str++++++== ',str);*/
                component.set("v.Detail",res);
            }
        });
        $A.enqueueAction(action2);
    } 
    
})