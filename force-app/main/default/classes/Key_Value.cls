public with sharing class Key_Value {
    @AuraEnabled public String key { get; set; }
    @AuraEnabled public String value { get; set; }
}