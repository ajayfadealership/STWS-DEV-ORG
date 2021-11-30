public class BoatController {
    @AuraEnabled
    public static String getBoatInfo(){
        BOATBUILDING__System_Configure__c mc = BOATBUILDING__System_Configure__c.getOrgDefaults();
        String boatKey = '';
        if(mc.BOATBUILDING__Boats_com_Feed_API_Key__c != null){
            boatKey = mc.BOATBUILDING__Boats_com_Feed_API_Key__c ;
        }
        HttpRequest req = new HttpRequest();
        req.setEndPoint('http://api.boats.com/inventory/search?key='+boatKey);
        req.setMethod('GET');
        req.setHeader('Content-Type','applciation/json');
        Http objHttp = new Http();
        HttpResponse res = objHttp.send(req);
        System.debug(res.getBody());
        return res.getBody();
    }
    @AuraEnabled
    public static String getInventoryById(String id){
        BOATBUILDING__System_Configure__c mc = BOATBUILDING__System_Configure__c.getOrgDefaults();
        String boatKey = '';
        if(mc.BOATBUILDING__Boats_com_Feed_API_Key__c != null){
            boatKey = mc.BOATBUILDING__Boats_com_Feed_API_Key__c ;
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.boats.com/inventory/'+id+'?key='+boatKey);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        Http objHttp = new Http();
        httpResponse res = objHttp.send(req);
        System.debug('>>>>>>res.getBody(): '+res.getBody());
        return res.getBody();
    }
    
    @AuraEnabled 
    public static String addUsedInventory(String id){
        BOATBUILDING__System_Configure__c mc = BOATBUILDING__System_Configure__c.getOrgDefaults();
        String boatKey = '';
        if(mc.BOATBUILDING__Boats_com_Feed_API_Key__c != null){
            boatKey = mc.BOATBUILDING__Boats_com_Feed_API_Key__c ;
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.boats.com/inventory/'+id+'?key='+boatKey);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        Http objHttp = new Http();
        httpResponse res = objHttp.send(req);
        System.debug('>>>>>>res.getBody(): '+res.getBody());
        String resJSON = res.getBody();
        BoatAddUsedInventoryWrapper obj = BoatAddUsedInventoryWrapper.parse(resJSON);
        System.debug('>>>>wrapper '+ obj);
        
        List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
        Id InvRecTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Used Boats').getRecordTypeId();
        if(obj.results != null && !obj.results.isEmpty()){
            for(integer i=0 ; i< obj.results.size() ; i++){
                BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
                if(InvRecTypeId != null)
                    objInv.RecordTypeId = InvRecTypeId;
                if(obj.results[i].BeamMeasure != null)
                    objInv.BOATBUILDING__Beam__c = obj.results[i].BeamMeasure;
                if(obj.results[i].MakeString != null)
                    objInv.BOATBUILDING__Manufacturer__c = obj.results[i].MakeString;
                if(obj.results[i].ModelYear != null)
                    objInv.BOATBUILDING__Year__c = String.valueOf(obj.results[i].ModelYear);
                if(obj.results[i].GeneralBoatDescription != null)
                    objInv.BOATBUILDING__Web_Description__c =String.valueOf(obj.results[i].GeneralBoatDescription[0]).stripHtmlTags(); 
                if(obj.results[i].DryWeightMeasure != null)
                    objInv.BOATBUILDING__Boat_Weight__c = obj.results[i].DryWeightMeasure;
                if(obj.results[i].BallastWeightMeasure != null)
                    objInv.BOATBUILDING__Boat_Ballast_Weight__c = obj.results[i].BallastWeightMeasure;
                if(obj.results[i].BoatHullMaterialCode != null)
                    objInv.BOATBUILDING__Hull_Material__c = obj.results[i].BoatHullMaterialCode;
                if(obj.results[i].BoatHullID != null)
                    objInv.BOATBUILDING__Hull_ID__c = obj.results[i].BoatHullID;
                if(obj.results[i].NominalLength != null)
                    objInv.BOATBUILDING__Boat_Length_in_feets__c = obj.results[i].NominalLength;
                if(obj.results[i].NormNominalLength != null)
                    objInv.BOATBUILDING__Boat_Overall_Length__c = String.valueOf(obj.results[i].NormNominalLength);
                if(obj.results[i].BoatCategoryCode != null)
                    objInv.BOATBUILDING__Category__c = obj.results[i].BoatCategoryCode;
                //   if(obj.results[i].Price != null)
                //  objInv.BOATBUILDING__Cost__c = Decimal.valueOf(obj.results[i].Price) ;
                if(obj.results[i].DocumentID != null)
                    objInv.BOATBUILDING__Source_System_Id__c = obj.results[i].DocumentID;
                if(obj.results[i].Model != null)
                    objInv.BOATBUILDING__Model__c = obj.results[i].Model;
                if(obj.results[i].StockNumber != null)
                    objInv.BOATBUILDING__Dealer_Boat_Stock__c = obj.results[i].StockNumber;
                if(obj.results[i].SalesStatus != null)
                    objInv.BOATBUILDING__UsedBoatStatus__c = obj.results[i].SalesStatus;
                if(obj.results[i].Engines[0].Type != null)
                    objInv.BOATBUILDING__Engine__c = obj.results[i].Engines[0].Type;
                if(obj.results[i].Engines[0].Model != null)
                    objInv.BOATBUILDING__Engine_Model__c = obj.results[i].Engines[0].Model;
                if(obj.results[i].Engines[0].Make != null)
                    objInv.BOATBUILDING__Engine_Make__c = obj.results[i].Engines[0].Make;
                if(obj.results[i].SalesStatus != null)
                    objInv.BOATBUILDING__Boat_Name__c = obj.results[i].BoatName;
                if(obj.results[i].CompanyName != null)
                    objInv.BOATBUILDING__Dealer__c = obj.results[i].CompanyName;
                If(obj.results[i].BoatLocation.BoatCityName != null || obj.results[i].BoatLocation.BoatStateCode != null){
                    objInv.BOATBUILDING__Location__c = obj.results[i].BoatLocation.BoatCityName +' '+ obj.results[i].BoatLocation.BoatStateCode; 
                }
                if(obj.results[i].ItemReceivedDate != null)
                    objInv.BOATBUILDING__Date_Arrived__c = Date.valueOf(obj.results[i].ItemReceivedDate);
                
                /*   objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Engines[0].EnginePower;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Engines[0].Fuel;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].HoldingTankCapacityMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].HoldingTankMaterialCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].WaterTankMaterialCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].WaterTankCapacityMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].DisplacementMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].CabinHeadroomMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].DisplacementTypeCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].FreeBoardMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].TotalEnginePowerQuantity;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].LastModificationDate;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].DriveTypeCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BridgeClearanceMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatKeelCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].RangeMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].MaximumSpeedMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].WindlassTypeCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].PropellerCruisingSpeed;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].DeadriseMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].CruisingSpeedMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].ElectricalCircuitMeasure;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].DesignerName;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BuilderName;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatNameNoCaseAlnumOnly;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatName;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].ModelNoCaseAlnumOnly;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].ModelExact;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].LengthOverall; // in SF size is 4
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BtolID;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].SaleClassCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].YachtWorldID;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].RegistrationCountryCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].DriveUp;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].MakeStringNoCaseAlnumOnly;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].TaxStatusCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].MakeStringExact;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].IMTTimeStamp;

objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatCityNameNoCaseAlnumOnly;

objInv.BOATBUILDING__Manufacturer__c = obj.results[i].NormPrice;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].CoOpIndicator;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Source;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].HoldingTankCountNumeric;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].WaterTankCountNumeric;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].ConvertibleSaloonIndicator;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].TrimTabsIndicator;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].HeadsCountNumeric;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].HasBoatHullID;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].IsAvailableForPls;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].OptionActiveIndicator;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].PriceHideInd;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].EmbeddedVideoPresent;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Image360PhotoPresent;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].NumberOfEngines;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatLocation.BoatStateCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatLocation.BoatCountryID;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].BoatLocation.BoatCityName;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.Name;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.PostCode;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.Country;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.State;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.Email;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.City;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.Phone;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Office.PostalAddress;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].SalesRep.Name;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].SalesRep.PartyId;
objInv.BOATBUILDING__Manufacturer__c = obj.results[i].Owner.PartyId;

*/
                
                
                
                System.debug('>>>>>objInv:'+objInv);
                lstInv.add(objInv);  
            }
            System.debug('>>>>size of lst:  '+ lstInv.size());
            upsert lstInv BOATBUILDING__Source_System_Id__c;
            System.debug('>>>>>>lstInv:: '+lstInv);
        } 
        if(! lstInv.isEmpty() && lstInv[0].Id != null){
            return lstInv[0].Id;
        }
        else {
            return 'unableToAddInventory';
            }
    }   
}