public with sharing class createenduserCase {

    public id AccountId {get; set;}
    public id ContactId {get; set;}
    public id AssetId {get; set;}
    
    
    public string contact {get; set;}
   
    public createenduserCase(ApexPages.StandardController controller) {

    }
    
    
    
     public PageReference populate() {
     LiveChatTranscript lc = [Select id, Body, End_User_Description__c, End_User_Institution__c, End_User_Institution_Role__c, End_User_Name__c, End_User_Phone__c,
                              End_User_Product__c, End_User_Subject__c from LiveChatTranscript]; 
     return null;
     }
    
 


}