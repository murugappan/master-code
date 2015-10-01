@istest
 Private class assetversionhistorytriggerhandlertest
  {
 
  static TestMethod void testHandler()
    {
     Test.startTest();    
        Asset_Version_History__c a = new Asset_Version_History__c ();
        a.Current_Build__c = '11';
        a.Current_Version__c='11.12345';
        a.Asset__c = '02i70000005Lg8j';
        insert a;
        Test.stopTest();
        
        
    }
   }