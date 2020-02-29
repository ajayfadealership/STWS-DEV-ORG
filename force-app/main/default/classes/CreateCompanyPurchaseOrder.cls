public class CreateCompanyPurchaseOrder
{

    public CreateCompanyPurchaseOrder()
    {
    
    }
    
    @RemoteAction
    public static BOATBUILDING__Manufacturer__c createVendor(String vendorName)
    {
        try{
        Id RecordTypeId = Schema.Sobjecttype.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        BOATBUILDING__Manufacturer__c objMFV = new BOATBUILDING__Manufacturer__c();
        objMFV.Name = vendorName;
        objMFV.RecordTypeId = RecordTypeId;
        insert objMFV;
        return objMFV;
        }
        catch(Exception e)
        {
            //ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString());
            return null;
        }
    }
    
}