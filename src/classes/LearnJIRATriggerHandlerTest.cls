@istest
 Private class LearnJIRATriggerHandlerTest
  {
   static Testmethod void testHandler()
    {
        Account a = TestMethodUtility.createAccount();
        insert a;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;
        
        Test.startTest();           
            learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
            insert lj;
            Case c2 = TestMethodUtility.createCase(con, cl, a, m);
            c2.LearnJIRA_SI__c = lj.Id;
            insert c2;
            update lj;
        Test.stopTest();
    }
  }