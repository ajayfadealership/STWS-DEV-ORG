public class DoAuthentication{
    
    public static String year{get;set;}
    public static String objecttoimport{get;set;}
    public static String Manufacturers {get;set;}
    public List < SelectOption > getItems() {
        
        list < ExternalDatabaseConfig__c > ExternalDatabaseConfiglst = [select id, name, Dealer_Id__c, Manufactor_Id__c, Password__c, Token__c, UserName__c from ExternalDatabaseConfig__c];
        List < SelectOption > options = new List < SelectOption > ();
        if (ExternalDatabaseConfiglst != null && ExternalDatabaseConfiglst.size() > 0) {
            for (ExternalDatabaseConfig__c objExternalDatabaseConfig: ExternalDatabaseConfiglst)
                
            {
                options.add(new SelectOption(objExternalDatabaseConfig.id, objExternalDatabaseConfig.name));
            }            
        }
        return options;
    }
    public List < SelectOption > getyearvalues() {   
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('2018','2018'));
        options.add(new SelectOption('2017','2017'));
        options.add(new SelectOption('2016','2016'));
        options.add(new SelectOption('2015','2015'));
        options.add(new SelectOption('2014','2014'));
        options.add(new SelectOption('2013','2013'));
        options.add(new SelectOption('2012','2012'));
        options.add(new SelectOption('2011','2011'));
        options.add(new SelectOption('2010','2010'));
        return options;
    }
    public List < SelectOption > getobjectvalues() {   
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Inventory','Inventory'));
        options.add(new SelectOption('ProductPrice','ProductPrice'));  
        return options;       
    }   
    public static string tokentoshow {get;set;} 
    public static string Importmsg{get;set;}
    public static void docallout() {
        list < ExternalDatabaseConfig__c > ExternalDatabaseConfiglst = [select id, name, Dealer_Id__c, Manufactor_Id__c, Password__c, Token__c, UserName__c from ExternalDatabaseConfig__c where id = : Manufacturers];
        if (ExternalDatabaseConfiglst != null) {
            String username = ExternalDatabaseConfiglst[0].UserName__c;
            String password = ExternalDatabaseConfiglst[0].Password__c;
            String dealer = ExternalDatabaseConfiglst[0].Dealer_Id__c;
            String manufactor = ExternalDatabaseConfiglst[0].Manufactor_Id__c;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://remote.southtownwatersports.com/importer/homes/login');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            // Set the body as a JSON object
            // request.setBody('username=remotest_stwdb&dealer_id=1&manufacturer_id=1&password=I8m;yr[5%wb2');
            request.setBody('username=' + username + '&dealer_id=' + dealer + '&manufacturer_id=' + manufactor + '&password=' + password);            
            system.debug('requestsent' + request.getbody());
            HttpResponse response = http.send(request);
            // Parse the JSON response
            System.debug(response.getStatusCode() + ' ' + response.getStatus());            
            System.debug(response.getBody());
            ExternalDbCalloutResponse objrespone = (ExternalDbCalloutResponse) JSON.deserializeStrict(response.getBody(), ExternalDbCalloutResponse.class);
            system.debug('vivekobjrespone' + objrespone.response.token);
            Map < String, object > results = (Map < String, object > ) JSON.deserializeUntyped(response.getBody());
            system.debug('responsemap' + results.get('response'));            
            tokentoshow = String.valueof(results.get('response'));
            system.debug('Token is' + tokentoshow);
            ExternalDatabaseConfiglst[0].Token__c = objrespone.response.token;
            update ExternalDatabaseConfiglst[0];
            
        }        
    }   
    public static void docallouttoImport() {        
        list < ExternalDatabaseConfig__c > ExternalDatabaseConfiglst = [select id, name, Dealer_Id__c, Manufactor_Id__c, Password__c, Token__c, UserName__c from ExternalDatabaseConfig__c where id = : Manufacturers and Token__c!=null];
        if (ExternalDatabaseConfiglst != null) {
            //String username = ExternalDatabaseConfiglst[0].UserName__c;
            //String password = ExternalDatabaseConfiglst[0].Password__c;
            //String dealer = ExternalDatabaseConfiglst[0].Dealer_Id__c;
            //String manufactor = ExternalDatabaseConfiglst[0].Manufactor_Id__c;
            String tokenid = ExternalDatabaseConfiglst[0].Token__c;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            if(objecttoimport == 'Inventory')
            {
                request.setEndpoint(' http://remote.southtownwatersports.com/importer/homes/getManufacturer');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                // Set the body as a JSON object
                // request.setBody('username=remotest_stwdb&dealer_id=1&manufacturer_id=1&password=I8m;yr[5%wb2');
                request.setBody('token='+tokenid +'&year=' + year);
                
                system.debug('requestsent' + request.getbody());
                HttpResponse response = http.send(request);
                // Parse the JSON response
                System.debug(response.getStatusCode() + ' ' + response.getStatus());
                
                System.debug(response.getBody());
                ExternalDataBaseResponse objrespone = (ExternalDataBaseResponse) JSON.deserializeStrict(response.getBody(), ExternalDataBaseResponse.class);
                system.debug('vivekobjresponeManufacturer' + objrespone.response.Manufacturer.Contact_Person);
                system.debug('vivekobjrespone Inventory' + objrespone.response.Inventory[0].id);
                
                Map < String, object > results = (Map < String, object > ) JSON.deserializeUntyped(response.getBody());
                system.debug('responsemap' + results.get('response'));
                
                //tokentoshow = String.valueof(results.get('response'));
                
                //system.debug('Token is' + tokentoshow);
                //ExternalDatabaseConfiglst[0].Token__c = objrespone.response.token;
                //update ExternalDatabaseConfiglst[0];
                Importmsg = 'Data has been Imported sucessfully!!. Please go to inventory tab and verfiy the data';
                
                list<Inventory__c>Inventorylst = new list<Inventory__c>();
                map<Integer,list<Inventory_Line_Item__c>>mapofinventortylst = new map<Integer,list<Inventory_Line_Item__c>>();
                if(objrespone.response.Inventory!=null)
                {
                    Integer i=0;
                    for(ExternalDataBaseResponse.Inventory objinv :objrespone.response.Inventory)
                    {
                        Inventory__c onjInventory = new Inventory__c();
                        //onjInventory.ACV__c = Decimal.valueof(objinv.ACV);
                        onjInventory.Backup_Camera__c = objinv.Backup_Camera;
                        onjInventory.Beam__c = objinv.Beam;
                        
                        onjInventory.Bin__c = objinv.Bin;
                        onjInventory.Board_racks__c = objinv.Board_racks;
                        onjInventory.Bow__c = objinv.Bow;
                        onjInventory.Interior_Design_Bow__c = objinv.Interior_Design_Bow;
                        onjInventory.B_roll__c = objinv.B_roll;
                        onjInventory.Cabin__c = objinv.Cabin;
                        
                        onjInventory.Category__c = objinv.Category;
                        onjInventory.Color__c = objinv.Color;
                        onjInventory.Convertible_seating__c = objinv.Convertible_seating;
                        onjInventory.Cooler__c = objinv.Cooler;
                        onjInventory.Cost__c = Decimal.valueof(objinv.Cost);
                        onjInventory.Curtailment_Start_Date__c = Date.valueof(objinv.Curtailment_Start_Date);
                        onjInventory.Dash_cluster__c = objinv.Dash_cluster;
                        onjInventory.Dash_Screen__c = objinv.Dash_Screen;
                        onjInventory.Date_Arrived__c = Date.valueof(objinv.Date_Arrived);
                        onjInventory.Date_First_on_Sales_Lot__c = Date.valueof(objinv.Date_First_on_Sales_Lot);
                        onjInventory.Date_on_FloorPlan__c = Date.valueof(objinv.Date_on_FloorPlan);
                        //onjInventory.Days_on_Lot__c = objinv.Days_on_Lot;
                        onjInventory.Family__c = objinv.Family;
                        onjInventory.HIN_Number__c = objinv.HIN_Number;
                        onjInventory.Hull_ID__c = objinv.Hull_ID;
                        onjInventory.Hull_Material__c = objinv.Hull_Material;
                        //onjInventory.In_Stock_Cost__c = objinv.In_Stock_Cost;
                        onjInventory.Interest_Start_Date__c = Date.valueof(objinv.Interest_Start_Date);
                        onjInventory.Manufacture_Invoice__c = objinv.Manufacture_Invoice;
                        onjInventory.Manufacturer__c = objinv.Manufacturer;
                        onjInventory.Map_Price__c = Decimal.valueof(objinv.Map_Price);
                        onjInventory.Mfg_Invoice__c = Decimal.valueof(objinv.Mfg_Invoice);
                        onjInventory.Minimum_Amount__c = Decimal.valueof(objinv.Minimum_Amount);
                        //onjInventory.Minimum_Sell_Price__c = objinv.Minimum_Sell_Price;
                        onjInventory.Model__c = objinv.Model;
                        onjInventory.Model_Variant__c = objinv.Model_Variant;
                        onjInventory.Net_Weight__c = Decimal.valueof(objinv.Net_Weight);
                        onjInventory.Owner__c = objinv.Owner;
                        onjInventory.Part_Location__c = objinv.Part_Location;
                        onjInventory.Part_MSRP_Price__c = Decimal.valueof(objinv.Part_MSRP_Price);
                        onjInventory.Part_Name__c = objinv.Part_Name;
                        onjInventory.Part_Number__c = objinv.Part_Number;
                        onjInventory.Phone_holder__c = objinv.Phone_holder;
                        
                        onjInventory.Quantity__c = Decimal.valueof(objinv.Quantity);
                        onjInventory.Running_gear__c = objinv.Running_gear;
                        onjInventory.Serial_Number_2__c = objinv.Serial_Number_2;
                        onjInventory.Side__c = objinv.Side;
                        onjInventory.Size__c = objinv.Size;
                        onjInventory.Speed_Wakeplate_levers__c = objinv.Speed_Wakeplate_levers;
                        onjInventory.Stage__c = objinv.Stage;
                        onjInventory.Status__c = objinv.Status;
                        onjInventory.UsedBoatStatus__c = objinv.UsedBoatStatus;
                        //onjInventory.Status_for_Curtailment_Start_Date__c = objinv.Status_for_Curtailment_Start_Date;
                        //onjInventory.Status_for_Days_on_the_Lot__c = objinv.Status_for_Days_on_the_Lot;
                        onjInventory.Quantity__c = Decimal.valueof(objinv.Quantity);
                        
                        onjInventory.Running_gear__c = objinv.Running_gear;
                        onjInventory.Serial_Number_2__c = objinv.Serial_Number_2;
                        onjInventory.Side__c = objinv.Side;
                        onjInventory.Size__c = objinv.Size;
                        onjInventory.Speed_Wakeplate_levers__c = objinv.Speed_Wakeplate_levers;
                        onjInventory.Stage__c = objinv.Stage;
                        onjInventory.Year__c = objinv.Year;
                        onjInventory.Weight__c = objinv.Weight;
                        onjInventory.Walkthrough__c = objinv.Walkthrough;
                        onjInventory.Vehicle_Type__c = objinv.Vehicle_Type;
                        onjInventory.Underwater_lights__c = objinv.Underwater_lights;
                        onjInventory.Transom_remote__c = objinv.Transom_remote;
                        onjInventory.Transom__c = objinv.Transom;
                        onjInventory.Transmission_Gearbox_SN__c = objinv.Transmission_Gearbox_SN;
                        onjInventory.Tower_speakers__c = objinv.Tower_speakers;
                        onjInventory.Transmission_Gearbox_SN__c = objinv.Transmission_Gearbox_SN;
                        onjInventory.Tower_speakers__c = objinv.Tower_speakers;
                        onjInventory.Total_MSRP_Price__c = Decimal.valueof(objinv.Total_MSRP_Price);
                        onjInventory.Total_Dealer_Price__c = Decimal.valueof(objinv.Total_Dealer_Price);
                        //onjInventory.Taxable__c = Decimal.valueof(objinv.Taxable);
                        onjInventory.Surf_system__c = objinv.Surf_system;
                        onjInventory.Suggested_List_Price__c = Decimal.valueof(objinv.Suggested_List_Price);
                        onjInventory.Steering_wheel_controls__c = objinv.Steering_wheel_controls;
                        //onjInventory.Status_for_Interest_Start_Date__c = objinv.Status_for_Interest_Start_Date;
                        //onjInventory.Status_for_Days_on_the_Lot__c = objinv.Status_for_Days_on_the_Lot;
                        
                        onjInventory.Boat_Ballast_Weight__c = objinv.InventoryBoatDetail.Boat_Ballast_Weight;
                        onjInventory.Boat_Capacities__c = objinv.InventoryBoatDetail.Boat_Capacities;
                        onjInventory.Boat_Cargo_Capacity__c = objinv.InventoryBoatDetail.Boat_Cargo_Capacity;
                        //onjInventory.Boat_Costline__c = Decimal.valueof(objinv.InventoryBoatDetail.Boat_Costline);
                        //onjInventory.Boat_Draft__c = objinv.InventoryBoatDetail.Boat_Draft;
                        //onjInventory.Boat_Fuel_Capacity__c = objinv.InventoryBoatDetail.Boat_Fuel_Capacity;
                        onjInventory.Boat_Length_in_feets__c = objinv.InventoryBoatDetail.Boat_Length_in_feets;
                        onjInventory.Boat_Overall_Length__c = objinv.InventoryBoatDetail.Boat_Overall_Length;
                        onjInventory.Boat_Seating_Capacity__c = objinv.InventoryBoatDetail.Boat_Seating_Capacity;
                        onjInventory.Boat_Type__c = objinv.InventoryBoatDetail.Boat_Type;
                        onjInventory.Boat_Weight__c = objinv.InventoryBoatDetail.Boat_Weight;
                        onjInventory.Boat_Weight_Maximum_Capacity__c = objinv.InventoryBoatDetail.Boat_Weight_Maximum_Capacity;
                        
                        onjInventory.Boat_Weight__c = objinv.InventoryCostlineDetail.Costline;
                        onjInventory.Boat_Weight__c = objinv.InventoryCostlineDetail.Costline_Points;
                        onjInventory.Boat_Weight__c = objinv.InventoryCostlineDetail.Costline_Value;
                        
                        
                        onjInventory.Dealer__c = objinv.InventoryDealerDetail.Dealer;
                        onjInventory.Dealer_Base_Price__c = Decimal.valueof(objinv.InventoryDealerDetail.Dealer_Base_Price);
                        onjInventory.Dealer_COD_Discount__c = Decimal.valueof(objinv.InventoryDealerDetail.Dealer_COD_Discount);
                        onjInventory.Dealer_Comments__c = objinv.InventoryDealerDetail.Dealer_Comments;
                        //onjInventory.Dealer_Discount__c = Decimal.valueof(objinv.InventoryDealerDetail.Dealer_Discount);
                        onjInventory.Dealer_Flat_Discount__c = Decimal.valueof(objinv.InventoryDealerDetail.Dealer_Flat_Discount);
                        //onjInventory.Dealer_Prep__c = Decimal.valueof(objinv.InventoryDealerDetail.Dealer_Prep);
                        onjInventory.Dealer_Status__c = objinv.InventoryDealerDetail.Dealer_Status;
                        onjInventory.Dealer_Stock__c = Decimal.valueof(objinv.InventoryDealerDetail.Dealer_Stock);
                        onjInventory.Description__c = objinv.InventoryDealerDetail.Description;
                        onjInventory.Discount__c = Decimal.valueof(objinv.InventoryDealerDetail.Discount);
                        //onjInventory.Display_On_Web__c = objinv.InventoryDealerDetail.Display_On_Web;
                        
                        onjInventory.Engine__c = objinv.InventoryEngineDetail.Engine;
                        onjInventory.Engine_compartment__c = objinv.InventoryEngineDetail.Engine_compartment;
                        onjInventory.Engine_Make__c = objinv.InventoryEngineDetail.Engine_Make;
                        onjInventory.Engine_Model__c = objinv.InventoryEngineDetail.Engine_Model;
                        onjInventory.Engine_SN__c = objinv.InventoryEngineDetail.Engine_SN;
                        onjInventory.Engine_Year__c = objinv.InventoryEngineDetail.Engine_Year;
                        
                        onjInventory.Extra_Pic_Four__c = objinv.InventoryExtraDetail.Extra_Pic_Four;
                        onjInventory.Extra_Pic_one__c = objinv.InventoryExtraDetail.Extra_Pic_one;
                        onjInventory.Extra_Pic_Three__c = objinv.InventoryExtraDetail.Extra_Pic_Three;
                        onjInventory.Extra_Pic_Two__c = objinv.InventoryExtraDetail.Extra_Pic_Two;
                        
                        onjInventory.Trailer_Axles__c = objinv.InventoryTrailerDetail.Trailer_Axles;
                        onjInventory.Trailer_ID__c = objinv.InventoryTrailerDetail.Trailer_ID;
                        onjInventory.Trailer_Make__c = objinv.InventoryTrailerDetail.Trailer_Make;
                        onjInventory.Trailer_Model__c = objinv.InventoryTrailerDetail.Trailer_Model;
                        onjInventory.Trailer_VIN__c = objinv.InventoryTrailerDetail.Trailer_VIN;
                        onjInventory.Trailer_wheels__c = objinv.InventoryTrailerDetail.Trailer_wheels;
                        onjInventory.Trailer_Year__c = objinv.InventoryTrailerDetail.Trailer_Year;
                        
                        
                        
                        onjInventory.Web_360_Video__c = objinv.InventoryWebDetail.Web_360_Video;
                        onjInventory.Web_Boat_Length__c = Decimal.valueof(objinv.InventoryWebDetail.Web_Boat_Length);
                        onjInventory.Web_Color__c = objinv.InventoryWebDetail.Web_Color;
                        //onjInventory.Web_Condition__c = objinv.InventoryWebDetail.Web_Condition;
                        
                        onjInventory.Web_Description__c = objinv.InventoryWebDetail.Web_Description;
                        onjInventory.Web_Engine__c = objinv.InventoryWebDetail.Web_Engine;
                        //onjInventory.Web_Engine_HP__c = Decimal.valueof(objinv.InventoryWebDetail.Web_Engine_HP);
                        onjInventory.Web_Fuel_Type__c = objinv.InventoryWebDetail.Web_Fuel_Type;
                        //onjInventory.Web_Hull_Material__c = objinv.InventoryWebDetail.Web_Hull_Material;
                        onjInventory.Web_Location__c = objinv.InventoryWebDetail.Web_Location;
                        //onjInventory.Web_Make__c = objinv.InventoryWebDetail.Web_Make;
                        
                        onjInventory.Web_Price__c = Decimal.valueof(objinv.InventoryWebDetail.Web_Price);
                        //onjInventory.Web_Product_ID__c = objinv.InventoryWebDetail.Web_Product_ID;
                        
                        //onjInventory.Web_Model__c = objinv.InventoryWebDetail.Web_Model;
                        onjInventory.Web_Product_Name__c = objinv.InventoryWebDetail.Web_Product_Name;
                        //onjInventory.Web_Propulsion__c = objinv.InventoryWebDetail.Web_Propulsion;
                        onjInventory.Web_Video__c = objinv.InventoryWebDetail.Web_Video;
                        onjInventory.Web_width__c = Decimal.valueof(objinv.InventoryWebDetail.Web_width);
                        //onjInventory.Web_Year__c = objinv.InventoryWebDetail.Web_Year;
                        //onjInventory.Web_Make__c = objinv.InventoryWebDetail.Web_Make;
                        Inventorylst.add(onjInventory);
                        if(objinv.InventoryLineItem!=null)
                        {
                            list<Inventory_Line_Item__c>InventoryLineItemlst = new list<Inventory_Line_Item__c>();
                            
                            for(ExternalDataBaseResponse.InventoryLineItem  objinvlineitem :objinv.InventoryLineItem)
                            {
                                Inventory_Line_Item__c objInventory_Line_Item = new Inventory_Line_Item__c();
                                objInventory_Line_Item.Dealer_Price__c = Decimal.valueof(objinvlineitem.Dealer_Price);
                                objInventory_Line_Item.Name__c = 'test';
                                objInventory_Line_Item.Discount__c = Decimal.valueof(objinvlineitem.Discount);
                                objInventory_Line_Item.Item_Description__c = objinvlineitem.Item_Description;
                                objInventory_Line_Item.Option_Category__c = objinvlineitem.Option_Category;
                                objInventory_Line_Item.Price__c = Decimal.valueof(objinvlineitem.Price);
                                objInventory_Line_Item.Product_Code__c = objinvlineitem.Product_Code;
                                objInventory_Line_Item.Quantity__c = Decimal.valueof(objinvlineitem.Quantity);
                                InventoryLineItemlst.add(objInventory_Line_Item);
                            }
                            mapofinventortylst.put(i,InventoryLineItemlst);
                            i=i+1;
                        }   
                    }                    
                    if(Inventorylst!=null)
                        insert Inventorylst;
                    
                    list<Inventory_Line_Item__c>intfinallisttoinsert = new list<Inventory_Line_Item__c>();
                    if(mapofinventortylst!=null)
                        system.debug('vivekmapofinventortylst'+mapofinventortylst);
                    for(Integer j : mapofinventortylst.keyset())
                    { 
                        system.debug('vivek j'+j);
                        for(Inventory_Line_Item__c objlineitemtoinsert : mapofinventortylst.get(j))
                        { 
                            system.debug('vivekInventorylst[j].id'+Inventorylst[j].id);
                            objlineitemtoinsert.Related_to_Inventory__c =Inventorylst[j].id;
                            intfinallisttoinsert.add(objlineitemtoinsert);
                        }
                        
                    }
                    system.debug('vivekintlt'+intfinallisttoinsert);
                    if(intfinallisttoinsert!=null && intfinallisttoinsert.size()>0)
                        insert intfinallisttoinsert;
                }
            }
            
            else if(objecttoimport == 'ProductPrice')
                
            {
                request.setEndpoint('  http://remote.southtownwatersports.com/importer/homes/getProductPrice');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                // Set the body as a JSON object
                // request.setBody('username=remotest_stwdb&dealer_id=1&manufacturer_id=1&password=I8m;yr[5%wb2');
                request.setBody('token='+tokenid +'&year=' + year);
                
                system.debug('requestsent' + request.getbody());
                HttpResponse response = http.send(request);
                // Parse the JSON response
                System.debug(response.getStatusCode() + ' ' + response.getStatus());
                
                System.debug(response.getBody());
                ProductPriceReponseWrapper objrespone = (ProductPriceReponseWrapper) JSON.deserializeStrict(response.getBody(), ProductPriceReponseWrapper.class);
                
                list<ProductPrice__c>lstProductPrice = new list<ProductPrice__c>();
                if(objrespone.response!=null)
                {
                    for(ProductPriceReponseWrapper.Response objresprodprice :objrespone.response)
                    {  
                        ProductPrice__c objProductPrice = new ProductPrice__c();
                        
                        //objProductPrice.ACV__c = Decimal.valueof(objresprodprice.ProductPrice.ACV);
                        
                        //objProductPrice.Beam__c = Decimal.valueof(objresprodprice.ProductPrice.Beam);
                        objProductPrice.Boat_Type__c = objresprodprice.ProductPrice.Boat_Type;
                        objProductPrice.Cost__c = Decimal.valueof(objresprodprice.ProductPrice.Cost);
                        //objProductPrice.Costline__c = Decimal.valueof(objresprodprice.ProductPrice.Costline);
                        objProductPrice.Curtailments_Start_Date__c = Date.valueof(objresprodprice.ProductPrice.Curtailments_Start_Date);
                        objProductPrice.Date_on_FloorPlan__c = Date.valueof(objresprodprice.ProductPrice.Date_on_FloorPlan);
                        //objProductPrice.Days_on_the_Lot__c = Decimal.valueof(objresprodprice.ProductPrice.Days_on_the_Lot);
                        //objProductPrice.Dealer_Prep__c = Decimal.valueof(objresprodprice.ProductPrice.Dealer_Prep);
                        objProductPrice.Dealer_Price__c = Decimal.valueof(objresprodprice.ProductPrice.Dealer_Price);
                        objProductPrice.Engine__c = objresprodprice.ProductPrice.Engine;
                        objProductPrice.Engine_SN__c = objresprodprice.ProductPrice.Engine_SN;
                        objProductPrice.Hull_ID__c = objresprodprice.ProductPrice.Hull_ID;
                        //objProductPrice.Hull_Material__c = objresprodprice.ProductPrice.Hull_Material;
                        objProductPrice.Interest_Start_Date__c = Date.valueof(objresprodprice.ProductPrice.Interest_Start_Date);
                        //objProductPrice.Length__c = Decimal.valueof(objresprodprice.ProductPrice.Length);
                        objProductPrice.Location__c = objresprodprice.ProductPrice.Location;
                        objProductPrice.Model_Variant__c = objresprodprice.ProductPrice.Model_Variant;
                        objProductPrice.Net_Weight__c = Decimal.valueof(objresprodprice.ProductPrice.Net_Weight);
                        objProductPrice.Option_Category__c = objresprodprice.ProductPrice.Option_Category;
                        objProductPrice.Options__c = objresprodprice.ProductPrice.Options;
                        objProductPrice.Owner__c = objresprodprice.ProductPrice.Owner;
                        objProductPrice.Product_Code__c = objresprodprice.ProductPrice.Product_Code;
                        objProductPrice.ProductManufacturer__c = objresprodprice.ProductPrice.ProductManufacturer;
                        objProductPrice.Product_Model__c = objresprodprice.ProductPrice.Product_Model;
                        objProductPrice.ProductRetail_Price__c = Decimal.valueof(objresprodprice.ProductPrice.ProductRetail_Price);
                        objProductPrice.Select_Category__c = objresprodprice.ProductPrice.Select_Category;
                        
                        
                        objProductPrice.ProductSelected_Category__c = objresprodprice.ProductPrice.ProductSelected_Category;
                        objProductPrice.Sorting_Order__c = 1;//Decimal.valueof(objresprodprice.ProductPrice.Sorting_Order);
                        objProductPrice.Status__c = objresprodprice.ProductPrice.Status;
                        //objProductPrice.Suggested_List_Price__c = Decimal.valueof(objresprodprice.ProductPrice.Suggested_List_Price);
                        objProductPrice.Trailer_ID__c = objresprodprice.ProductPrice.Trailer_ID;
                        objProductPrice.Vehicle_Type__c = objresprodprice.ProductPrice.Vehicle_Type;
                        objProductPrice.Year__c = objresprodprice.ProductPrice.Year;
                        
                        lstProductPrice.add(objProductPrice);
                    }
                    
                }
                
                if(lstProductPrice!=null && lstProductPrice.size()>0)
                    insert lstProductPrice;
                Importmsg = 'Data has been Imported sucessfully!!. Please go to product price for selected category tab and verfiy the data';               
            }
        }        
    }
}