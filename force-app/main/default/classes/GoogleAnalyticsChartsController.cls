public class GoogleAnalyticsChartsController {
    
    public List<Data> Data {get; set;}
    public BOATBUILDING__Inventory__c objInventory;
    List<BOATBUILDING__Custom_Log__c> listCustomLog;
    
    public GoogleAnalyticsChartsController(ApexPages.StandardController controller) {
        this.objInventory = (BOATBUILDING__Inventory__c)controller.getRecord();
        listCustomLog = new List<BOATBUILDING__Custom_Log__c>();
    }
    
    public void storeAnalyticsData(){
        try{
            
            BOATBUILDING__Google_Analytics__c objGAToInsert = new BOATBUILDING__Google_Analytics__c();
            BOATBUILDING__GooglAnalyticsConfig__c objConfig = BOATBUILDING__GooglAnalyticsConfig__c.getOrgDefaults(); 
            
            
            String accessToken = String.isNotBlank(objConfig.BOATBUILDING__Access_Token__c) ? objConfig.BOATBUILDING__Access_Token__c: '';
            BOATBUILDING__Inventory__c objInv = [SELECT Id, BOATBUILDING__Web_Page_Name__c, BOATBUILDING__Website_Page_Name__c,
                                                 BOATBUILDING__Store_Location__c,
                                                 (SELECT Id, BOATBUILDING__Page_Visit_Date__c FROM BOATBUILDING__Google_Analytics__r
                                                  WHERE BOATBUILDING__Page_Visit_Date__c =: System.today())
                                                 FROM BOATBUILDING__Inventory__c WHERE Id=: objInventory.Id LIMIT 1];
            if(objInv != null){
                String webPageName = objInv.BOATBUILDING__Web_Page_Name__c;
                String storeLocation = '';
                List<BOATBUILDING__Store_Location_Config__mdt> lstStoreLocConfig = [SELECT Id, BOATBUILDING__Website_Store_location__c 
                                                                                    FROM BOATBUILDING__Store_Location_Config__mdt 
                                                                                    WHERE label =: objInv.BOATBUILDING__Store_Location__c];
                if(!lstStoreLocConfig.isEmpty()){
                    storeLocation = lstStoreLocConfig.get(0).BOATBUILDING__Website_Store_location__c;
                }


                BOATBUILDING.GoogleAnalyticsIntegration objGAI = new BOATBUILDING.GoogleAnalyticsIntegration();
                List<List<String>> listRows = new List<List<String>>();
                listCustomLog.addAll(CustomLogUtil.createLog('webPageName-- line 36---'+webPageName, 'GoogleAnalyticsChartsController'));
                listCustomLog.addAll(CustomLogUtil.createLog('accessToken-- line 37---'+accessToken, 'GoogleAnalyticsChartsController'));
                listCustomLog.addAll(CustomLogUtil.createLog('storeLocation-- line 38---'+storeLocation, 'GoogleAnalyticsChartsController'));
                listRows = objGAI.createRequest(webPageName, accessToken, storeLocation);
                
                if(!listRows.isEmpty()){
                    data = new List<Data>();
                    listCustomLog.addAll(CustomLogUtil.createLog('listRows-- line 43---'+listRows, 'GoogleAnalyticsChartsController'));
                    system.debug('listRows---'+listRows.size());
                    for(List<String> listR : listRows){
                        String pageName  = '';
                        String Year  = '';
                        String Month  = '';
                        String Day  = '';
                        Integer pageView  = 0;
                        for(Integer i = 0; i < listR.size(); i++) {
                            if(listR[i].containsIgnoreCase('-')) {
                                pageName = listR[i];    
                            } else if(listR[i].length() == 4 && Integer.valueOf(listR[i]) > 2000) {
                                Year = listR[i];
                            } else if(listR[i].length() == 2) {
                                if(i == 3) {
                                    Month = listR[i];
                                } else if(i == 4) {
                                    Day = listR[i];
                                }
                            } else if(i == listR.size() - 1) {
                                pageView = Integer.valueOf(listR[i]);
                            }
                        }
                        
                        Date pageViewDate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
                        if(!objInv.BOATBUILDING__Google_Analytics__r.isEmpty()){
                            for(BOATBUILDING__Google_Analytics__c objGA : objInv.BOATBUILDING__Google_Analytics__r){
                                if(objGA.BOATBUILDING__Page_Visit_Date__c == pageViewDate){
                                    objGAToInsert = new BOATBUILDING__Google_Analytics__c(Id = objGA.Id);
                                    objGAToInsert.BOATBUILDING__Page_Views__c = pageView;
                                }
                            }
                        } else {
                            objGAToInsert = new BOATBUILDING__Google_Analytics__c();
                            objGAToInsert.BOATBUILDING__Page_Visit_Date__c = pageViewDate;
                            objGAToInsert.BOATBUILDING__Page_Views__c = pageView;
                            objGAToInsert.BOATBUILDING__Inventory__c = objInv.Id;
                        }
                        
                        String viewDate = Month+'-'+Day+'-'+Year;
                        data.add(new Data(viewDate, pageView));
                    }
                    if(objGAToInsert != null){
                        upsert objGAToInsert;
                    }
                } 
            }

            if(!listCustomLog.isEmpty()){
                insert listCustomLog;
            }
        } catch(Exception e){
            System.debug('===GoogleAnalyticsChartsController ===='+e.getTypeName()+'Message: \n' + e.getMessage()+'Line number: \n' + e.getLineNumber()+'Stack trace: \n' + e.getStackTraceString());
            //SendEmailUtility.sendQuickEmail('===GoogleAnalyticsChartsController ===='+e.getTypeName()+'Message: \n' + e.getMessage()+'Line number: \n' + e.getLineNumber()+'Stack trace: \n' + e.getStackTraceString());
            listCustomLog.addAll(CustomLogUtil.createLog(e.getTypeName()+'Message: \n' + e.getMessage()+'Line number: \n' + e.getLineNumber()+'Stack trace: \n' + e.getStackTraceString(), 'GoogleAnalyticsChartsController'));
            if(!listCustomLog.isEmpty()){
                insert listCustomLog;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Currently no analytics data available.'));
        }
    }
    
    // Wrapper class
    public class Data {
        public String pageViewDate { get; set; }
        public Integer data1 { get; set; }
        public Data(String pageViewDate, Integer data1) {
            this.pageViewDate = pageViewDate;
            this.data1 = data1;
        }
    }
}