@istest
 Private class ManageSIOnCaseControllertest
  {
   static testmethod  void testController()
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
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        Related_Bug__c rb = TestMethodUtility.createRelatedBug(lj);
        insert rb;
        //Patch_Request__c p = TestMethodUtility.createPatchRequest(lj);
        //insert p;
              Test.startTest();
        Case_Support_Incident__c csi = TestMethodUtility.createCaseSupportIncident(c, lj);
        insert csi;
        
        // Updater code coverage
  
            PageReference pageRef = Page.ManageSIOnCase;
            pageRef.getParameters().put('id', c.Id);
            Test.setCurrentPageReference(pageRef);
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(c);
            ManageSIOnCaseController msicc = new ManageSIOnCaseController(stdController);
        Test.stopTest();
    }
  }