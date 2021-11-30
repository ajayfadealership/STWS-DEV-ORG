public class BoatAddUsedInventoryWrapper {
    
    public static BoatAddUsedInventoryWrapper parse(String json){
        return (BoatAddUsedInventoryWrapper) System.JSON.deserialize(json, BoatAddUsedInventoryWrapper.class);
    }
    public list<results> results{get;set;}
  //  public Integer numResults{get;set;}
    public class SalesRep{
   /*     public String Name{get;set;}
        public String PartyId{get;set;}*/
    }
    public class results{
     /*   public Integer HoldingTankCountNumeric{get;set;}
        public String HoldingTankCapacityMeasure{get;set;}
        public String HoldingTankMaterialCode{get;set;}
        public String WaterTankMaterialCode{get;set;}*/
        public String DryWeightMeasure{get;set;}
      //  public String WaterTankCapacityMeasure{get;set;}
        public String BallastWeightMeasure{get;set;}
      /*  public Integer WaterTankCountNumeric{get;set;}
        public String DisplacementMeasure{get;set;}
        public String CabinHeadroomMeasure{get;set;}
        public String DisplacementTypeCode{get;set;}
        public String FreeBoardMeasure{get;set;}
        public String TotalEnginePowerQuantity{get;set;}*/
        public String BeamMeasure{get;set;}
      /*  public String DriveTypeCode{get;set;}
        public String BridgeClearanceMeasure{get;set;}
        public String BoatKeelCode{get;set;}
        public String RangeMeasure{get;set;}
        public Boolean ConvertibleSaloonIndicator{get;set;}
        public String MaximumSpeedMeasure{get;set;}
        public String WindlassTypeCode{get;set;}
        public String PropellerCruisingSpeed{get;set;}
        public String DeadriseMeasure{get;set;} 
        public String CruisingSpeedMeasure{get;set;}
        public String ElectricalCircuitMeasure{get;set;}
        public String DesignerName{get;set;}
        public Boolean TrimTabsIndicator{get;set;}
        public String BuilderName{get;set;}
        public Integer HeadsCountNumeric{get;set;}
        public String BoatNameNoCaseAlnumOnly{get;set;}*/
        public String BoatHullMaterialCode{get;set;}
       public String BoatName{get;set;}
        public String BoatHullID{get;set;}
        public String BoatCategoryCode{get;set;}
        public String StockNumber{get;set;}
     //   public String ModelNoCaseAlnumOnly{get;set;}
        public String NominalLength{get;set;}
     //   public String ModelExact{get;set;}
      //  public String LengthOverall{get;set;}
        public String Model{get;set;}
      /*  public String BtolID{get;set;}
        public String SaleClassCode{get;set;}
        public String YachtWorldID{get;set;}*/
        public Integer ModelYear{get;set;}
      /*  public String DriveUp{get;set;}
        public String MakeStringNoCaseAlnumOnly{get;set;}
        public String TaxStatusCode{get;set;}
        public String MakeStringExact{get;set;}
        public String IMTTimeStamp{get;set;}*/
        public String MakeString{get;set;}
     //   public Boolean HasBoatHullID{get;set;}
     //   public String BoatCityNameNoCaseAlnumOnly{get;set;}
      /*  public Boolean IsAvailableForPls{get;set;}*/
        public BoatLocation BoatLocation{get;set;}
        public Decimal NormNominalLength{get;set;}
     //   public Boolean OptionActiveIndicator{get;set;}
     //   public String NormPrice{get;set;}
     /*   public Boolean PriceHideInd{get;set;}
        public Boolean EmbeddedVideoPresent{get;set;}*/
       /* public String Price{get;set;}
        public Boolean Image360PhotoPresent{get;set;}*/
        public String ItemReceivedDate{get;set;}
        public list<Engines> Engines{get;set;}
    //    public String LastModificationDate{get;set;}
    /*    public list<String> Service{get;set;}
        public Office Office{get;set;}*/
        public list<String> GeneralBoatDescription{get;set;}
        public String CompanyName{get;set;}
      /*  public SalesRep SalesRep{get;set;}
        public Owner Owner{get;set;}
        
        public list<String> BoatClassCode{get;set;}
        public String RegistrationCountryCode{get;set;}*/
      /*  public list<String> BoatClassCodeNoCaseAlnumOnly{get;set;}
        public Integer NumberOfEngines{get;set;}
        public list<String> AdditionalDetailDescription{get;set;}*/
     //   public String CoOpIndicator{get;set;}
     ////   public list<Images> Images{get;set;}
        public String SalesStatus{get;set;}
   //     public list<Marketing> Marketing{get;set;}
        public String DocumentID{get;set;}
     //   public list<String> EnhancementCode{get;set;}
      //  public String Source{get;set;}
    }
    public class Owner{
   //     public String PartyId{get;set;}
    }
    public class Office{
     /*   public String Name{get;set;}
        public String PostCode{get;set;}
        public String Country{get;set;}
        public String State{get;set;}
        public String Email{get;set;}
        public String City{get;set;}
        public String Phone{get;set;}
        public String PostalAddress{get;set;}*/
    }
    public class Marketing{
    /*    public String OpportunityType{get;set;}
        public String ProgramOffer{get;set;}
        public String ProgramDescription{get;set;}
        public String PublicationID{get;set;}
        public String ProgramID{get;set;}
        public String MarketingID{get;set;}
        public String OpportunityMethod{get;set;}*/
    }
    public class Images{
    /*    public String Uri{get;set;}
        public String Caption{get;set;}
        public String LastModifiedDateTime{get;set;}
        public String Priority{get;set;}*/
    }
    public class Engines{
        public String Make{get;set;}
    //    public String EnginePower{get;set;}
//        public String Fuel{get;set;}
        public String Type{get;set;}
        public String Model{get;set;}
    }
    public class BoatLocation{
       public String BoatStateCode{get;set;}
      //  public String BoatCountryID{get;set;}
        public String BoatCityName{get;set;}
    }
}