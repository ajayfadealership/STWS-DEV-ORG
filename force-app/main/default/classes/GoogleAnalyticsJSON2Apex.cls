/*
Developed By: Sajal Bansal
Purpose: Wrapper to parse Google Analytics response
*/

public class GoogleAnalyticsJSON2Apex {
    
    public String kind;
    public String id;
    public Query query;
    public Integer itemsPerPage;
    public Integer totalResults;
    public String selfLink;
    public ProfileInfo profileInfo;
    public Boolean containsSampledData;
    public List<ColumnHeaders> columnHeaders;
    public TotalsForAllResults totalsForAllResults;
    public List<List<String>> rows;
    
    public class ColumnHeaders {
        public String name;
        public String columnType;
        public String dataType;
    }
    
    public class Query {
        public String startdate;
        public String enddate;
        public String ids;
        public String dimensions;
        public List<String> metrics;
        public String filters;
        public Integer startindex;
        public Integer maxresults;
    }
    
    public class ProfileInfo {
        public String profileId;
        public String accountId;
        public String webPropertyId;
        public String internalWebPropertyId;
        public String profileName;
        public String tableId;
    }
    
    public class TotalsForAllResults {
        public String gapageviews;
    }
    
    public static GoogleAnalyticsJSON2Apex parse(String json) {
        return (GoogleAnalyticsJSON2Apex) System.JSON.deserialize(json, GoogleAnalyticsJSON2Apex.class);
    }
}