({
    changePPOption : function(component, event, helper) {
        var strPPId = component.get("v.strId");
        var ProductPriceIdListCCCC = component.get("v.ProductPriceIdListCCCC");
        var ProductPriceIdListQTCCCC = component.get("v.ProductPriceIdListQTCCCC");

        var QT = component.get("v.Quantity") != undefined && component.get("v.Quantity") != '' ? component.get("v.Quantity") : 1;
        
        var checkStatus = '0';
        if(component.find("ppcheck").get("v.value")) {
            checkStatus = '1';
        } 
        
        if(checkStatus == '1') {
            ProductPriceIdListCCCC.push(strPPId);
            ProductPriceIdListQTCCCC.push(strPPId + ':' + QT);
        } else { 
            ProductPriceIdListCCCC.splice(ProductPriceIdListCCCC.indexOf(strPPId), 1);
            ProductPriceIdListQTCCCC.splice(ProductPriceIdListQTCCCC.indexOf(strPPId + ':' + QT), 1);
        }
        component.set("v.ProductPriceIdListCCCC", ProductPriceIdListCCCC);
        component.set("v.ProductPriceIdListQTCCCC", ProductPriceIdListQTCCCC);
        console.log('>>>>>ProductPriceIdListQTCCCC:', ProductPriceIdListQTCCCC);
        console.log('>>>>>Quantity: ', component.get("v.Quantity"));
        console.log(ProductPriceIdListCCCC);
        var cmpEvent = $A.get("e.c:PPIdEvent");
        
        cmpEvent.setParams({
            "PPID": strPPId,
            "PPStatus": checkStatus,
            "PPQT": QT
        });
        cmpEvent.fire();
    },
    doInit: function(component, event, helper) {
    	var checkStatus = '0'; 
        var strPPId = component.get("v.strId");
        var ProductPriceIdListCCCC = component.get("v.ProductPriceIdListCCCC");
        var ProductPriceIdListQTCCCC = component.get("v.ProductPriceIdListQTCCCC");
        var QT = component.get("v.Quantity") != undefined && component.get("v.Quantity") != '' ? component.get("v.Quantity") : 1;
        if(component.get("v.objDOCheck")) {
            checkStatus = '1'; 
        }
        console.log("ProductPriceIdListCCCC.includes(strPPId): "+ProductPriceIdListCCCC.includes(strPPId));
        if(checkStatus == '1') {
            console.log("ProductPriceIdListCCCC.includes(strPPId): "+ProductPriceIdListCCCC.includes(strPPId));
            if(!ProductPriceIdListCCCC.includes(strPPId)) {
                ProductPriceIdListCCCC.push(strPPId); 
                ProductPriceIdListQTCCCC.push(strPPId + ':' + QT);
                console.log('ProductPriceIdListCCCC.length: '+ProductPriceIdListCCCC.length);
                console.log('ProductPriceIdListQTCCCC.length: ',ProductPriceIdListQTCCCC);
                var cmpEvent = $A.get("e.c:PPIdEvent");
                cmpEvent.setParams({
                    "PPID": strPPId,
                    "PPStatus": checkStatus,
                    "PPQT": component.get("v.Quantity") != undefined && component.get("v.Quantity") != '' ? component.get("v.Quantity") : 0
                });
                cmpEvent.fire();
            }
        }
    }
})