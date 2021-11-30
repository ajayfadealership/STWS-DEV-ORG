({
    updateTotal : function(component, event, helper) {
        var ProductPriceIdListCCCC = component.get("v.ProductPriceIdListCCCC");
        console.log("ProductPriceIdListCCCC: ", ProductPriceIdListCCCC)
        var strPPId = component.get("v.strId");
        console.log("strPPId: ", strPPId)

        var ProductPriceIdListQTCCCC = component.get("v.ProductPriceIdListQTCCCC");
        var QT = component.get("v.qt") != undefined && component.get("v.qt") != '' ? component.get("v.qt") : 1;
        if(ProductPriceIdListQTCCCC.length > 0) {
            for(var i = 0; i < ProductPriceIdListQTCCCC.length; i++) {
                if(ProductPriceIdListQTCCCC[i].includes(strPPId)) {
                    ProductPriceIdListQTCCCC.splice(i, 1);
                    ProductPriceIdListQTCCCC.push(strPPId + ':' + QT);
                }
            }
        }
        console.log('>>>ProductPriceIdListQTCCCC: ', ProductPriceIdListQTCCCC);
        component.set("v.ProductPriceIdListQTCCCC", ProductPriceIdListQTCCCC);
        var checkStatus = '0';
        if(component.get("v.isCheck")) {
            checkStatus = '1';
        }
        console.log("checkStatus: ", checkStatus)
        if(ProductPriceIdListCCCC.includes(strPPId)) {
            var cmpEvent = $A.get("e.c:PPIdEvent");
            cmpEvent.setParams({
                "PPID": strPPId,
                "PPStatus": checkStatus,
                "PPQT": QT
            });
            cmpEvent.fire();
        }
    }
})