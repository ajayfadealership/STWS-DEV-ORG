({
    changePPOption : function(component, event, helper) {
        var strPPId = component.get("v.strId");
        var ProductPriceIdListCCCC = component.get("v.ProductPriceIdListCCCC");
        var checkStatus = '0';
        if(component.find("ppcheck").get("v.value")) {
            checkStatus = '1';
        }
        
        if(checkStatus == '1') {
            ProductPriceIdListCCCC.push(strPPId); 
        } else { 
            ProductPriceIdListCCCC.splice(ProductPriceIdListCCCC.indexOf(strPPId), 1);
        }
        component.set("v.ProductPriceIdListCCCC", ProductPriceIdListCCCC);
        console.log('>>>>>:');
        console.log(ProductPriceIdListCCCC);
        var cmpEvent = $A.get("e.c:PPIdEvent");
        
        cmpEvent.setParams({
            "PPID": strPPId,
            "PPStatus": checkStatus
        });
        cmpEvent.fire();
    },
    doInit: function(component, event, helper) {
    	var checkStatus = '0'; 
        var strPPId = component.get("v.strId");
        var ProductPriceIdListCCCC = component.get("v.ProductPriceIdListCCCC");
        if(component.get("v.objDOCheck")) {
            checkStatus = '1'; 
        }
        console.log("ProductPriceIdListCCCC.includes(strPPId): "+ProductPriceIdListCCCC.includes(strPPId));
        if(checkStatus == '1') {
            console.log("ProductPriceIdListCCCC.includes(strPPId): "+ProductPriceIdListCCCC.includes(strPPId));
            if(!ProductPriceIdListCCCC.includes(strPPId)) {
                ProductPriceIdListCCCC.push(strPPId); 
                console.log('ProductPriceIdListCCCC.length: '+ProductPriceIdListCCCC.length);
                var cmpEvent = $A.get("e.c:PPIdEvent");
                cmpEvent.setParams({
                    "PPID": strPPId,
                    "PPStatus": checkStatus
                });
                cmpEvent.fire();
            }
        }
    }
})