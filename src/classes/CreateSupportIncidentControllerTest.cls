@isTest
Public class CreateSupportIncidentControllerTest
 {
  static testmethod void CreateSupportIncidentControllerTest(){
    
        Account a = TestMethodUtility.createAccount();
        insert a;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;
        Case c2 = TestMethodUtility.createCase(con, cl, a, m);
        insert c2;      
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        PageReference pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid',c.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lj);
        CreateSupportIncidentController csic = new CreateSupportIncidentController(stdController);
        csic.doSave();
        csic.doCancel();
        pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid', c2.Id);
        Test.setCurrentPageReference(pageRef);
        stdController = new ApexPages.StandardController(lj);
        csic = new CreateSupportIncidentController(stdController);
        csic.supportIncident.Private_Description__c = 'Test';
        csic.supportIncident.Summary__c = 'Test';
        csic.supportIncident.Tier_2_Assessment__c = 'Test';
        csic.setBType();
        csic.doSave();
        csic.doCancel();
        List<SelectOption> lo =csic.versions;
        csic.clearsb();
        List<SelectOption> lo1 =csic.sblist;
    }
    static testmethod void CreateSupportIncidentControllerTest1(){
    
        Account a = TestMethodUtility.createAccount();
        insert a;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Core_License__c cl = new  Core_License__c();
        cl.Name = 'Moodlerooms';
        insert cl;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;
        Case c2 = TestMethodUtility.createCase(con, cl, a, m);
        insert c2;      
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        PageReference pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid',c.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lj);
        CreateSupportIncidentController csic = new CreateSupportIncidentController(stdController);
        csic.doSave();
        csic.doCancel();
        pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid', c2.Id);
        Test.setCurrentPageReference(pageRef);
        stdController = new ApexPages.StandardController(lj);
        csic = new CreateSupportIncidentController(stdController);
        csic.supportIncident.Private_Description__c = 'Test';
        csic.supportIncident.Summary__c = 'Test';
        csic.supportIncident.Tier_2_Assessment__c = 'Test';
        csic.setBType();
        csic.doSave();
        csic.doCancel();
        List<SelectOption> lo =csic.versions;
        csic.clearsb();
        List<SelectOption> lo1 =csic.sblist;
    }
    static testmethod void CreateSupportIncidentControllerTes2(){
    
        Account a = TestMethodUtility.createAccount();
        insert a;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Core_License__c cl = new  Core_License__c();
        cl.Name = 'Collaborate';
        insert cl;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;
        Case c2 = TestMethodUtility.createCase(con, cl, a, m);
        insert c2;      
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        PageReference pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid',c.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lj);
        CreateSupportIncidentController csic = new CreateSupportIncidentController(stdController);
        csic.doSave();
        csic.doCancel();
        pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid', c2.Id);
        Test.setCurrentPageReference(pageRef);
        stdController = new ApexPages.StandardController(lj);
        csic = new CreateSupportIncidentController(stdController);
        csic.supportIncident.Private_Description__c = 'Test';
        csic.supportIncident.Summary__c = 'Test';
        csic.supportIncident.Tier_2_Assessment__c = 'Test';
        csic.setBType();
        csic.doSave();
        csic.doCancel();
        List<SelectOption> lo =csic.versions;
        csic.clearsb();
        List<SelectOption> lo1 =csic.sblist;
    }
    static testmethod void CreateSupportIncidentControllerTes3(){
        
        Account a = TestMethodUtility.createAccount();
        insert a;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Core_License__c cl = new  Core_License__c();
        cl.Name = 'Moodlerooms';
        insert cl;
        
        learnJIRA__c lj = new learnJIRA__c(Name = 'Test', Business_Unit__c = 'Moodlerooms', Tier_2_Assessment__c = 'This is a Bug', Summary__c = 'Test Summary', Status__c = 'New');
        insert lj;
        
        PageReference pageRef = Page.CreateSupportIncident;
      
        ApexPages.StandardController stdController = new ApexPages.StandardController(lj);
        CreateSupportIncidentController csic = new CreateSupportIncidentController(stdController);
        csic.doSave();
        csic.doCancel();
        pageRef = Page.CreateSupportIncident;
      
        Test.setCurrentPageReference(pageRef);
        stdController = new ApexPages.StandardController(lj);
        csic = new CreateSupportIncidentController(stdController);
        csic.supportIncident.Private_Description__c = 'Test';
        csic.supportIncident.Summary__c = 'Test';
        csic.supportIncident.Tier_2_Assessment__c = 'Test';
        csic.setBType();
        csic.doSave();
        csic.doCancel();
        List<SelectOption> lo =csic.versions;
        csic.clearsb();
        List<SelectOption> lo1 =csic.sblist;
    
   }
   static testmethod void CreateSupportIncidentControllerTest4(){
    
        Account a = TestMethodUtility.createAccount();
        insert a;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Core_License__c cl = new  Core_License__c();
        cl.Name = 'Moodlerooms';
        insert cl;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
      
        Asset aa = new Asset(Name = 'TestAsset', Core_License__c = cl.Id, Status = 'Installed', AccountId = a.Id, version__c='test');
        insert aa;
         
        Case c = new Case( AccountId = a.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = aa.Id, Core_License__c = cl.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
        insert c;
        
        Case c2 = new Case( AccountId = a.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = aa.Id, Core_License__c = cl.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
        insert c2;
            
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        PageReference pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid',c.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lj);
        CreateSupportIncidentController csic = new CreateSupportIncidentController(stdController);
        csic.doSave();
        csic.doCancel();
        pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid', c2.Id);
        Test.setCurrentPageReference(pageRef);
        stdController = new ApexPages.StandardController(lj);
        csic = new CreateSupportIncidentController(stdController);
        csic.supportIncident.Private_Description__c = 'Test';
        csic.supportIncident.Summary__c = 'Test';
        csic.supportIncident.Tier_2_Assessment__c = 'Test';
        csic.setBType();
        csic.doSave();
        csic.doCancel();
  //      Test.startTest(); 
  //      List<SelectOption> lo =csic.versions;
  //        Test.stopTest();
  //      csic.clearsb();
  //      List<SelectOption> lo1 =csic.sblist;
    } 
    static testmethod void CreateAnalyticsSI()
    {
       Account acc = TestMethodUtility.createAccount();
       insert acc;

       Contact con = TestMethodUtility.createContact(acc);
       insert con; 

       Core_License__c cr = new  Core_License__c();
       cr.Name = 'Analytics'; 
       insert cr;

       Module__c m = TestMethodUtility.createModule(cr);
       insert m;

       Asset a = new Asset(Name = 'TestAsset', Core_License__c = cr.Id, Status = 'Installed', AccountId = acc.Id, version__c='test',Version_Build__c = 'test');
       insert a;

       Case c = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = a.Id, Core_License__c = cr.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
       insert c; 

       system.debug('ajithh'+ cr.name);
       
       learnJIRA__c SI = TestMethodUtility.createSupportIncident(c);
       insert SI;

       PageReference pageRef = Page.CreateSupportIncident;
       pageRef.getParameters().put('cid',c.Id);
       ApexPages.StandardController stdController = new ApexPages.StandardController(SI);
       CreateSupportIncidentController ctr = new CreateSupportIncidentController(stdController);

       ctr.doSave();
       ctr.doCancel();
    }
    static testmethod void CreateAnalyticsSI1()
    {
       Account acc = TestMethodUtility.createAccount();
       insert acc;

       Contact con = TestMethodUtility.createContact(acc);
       insert con; 

       Core_License__c cr = new  Core_License__c();
       cr.Name = 'Analytics'; 
       insert cr;

       Module__c m = TestMethodUtility.createModule(cr);
       insert m;

       Asset a = new Asset(Name = 'TestAsset', Core_License__c = cr.Id, Status = 'Installed', AccountId = acc.Id, version__c='test',Version_Build__c = 'Test');
       insert a;

       Case c = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = a.Id, Core_License__c = cr.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '4');
       insert c; 

       learnJIRA__c SI = new learnJIRA__c(
            Name = 'Test',
            OriginCaseID__c = c.Id,
            Status__c = 'New');

       PageReference pageRef = Page.CreateSupportIncident;
       pageRef.getParameters().put('cid',c.Id);
       ApexPages.StandardController stdController = new ApexPages.StandardController(SI);
       CreateSupportIncidentController ctr = new CreateSupportIncidentController(stdController);
       
       ctr.supportIncident.Summary__c = 'Test';
       ctr.supportIncident.Tier_2_Assessment__c = 'Test';
       ctr.supportIncident.Type__c = 'Test';
       ctr.supportIncident.Reproduced__c ='Test';
       ctr.doSave();
       ctr.doCancel();
       
    } 
    static testmethod void CreateSupportIncidentControllerTestSI2()
    {
       Account acc = TestMethodUtility.createAccount();
       insert acc;

       Contact con = TestMethodUtility.createContact(acc);
       insert con;

       List<Core_License__c> crr = new List<Core_License__c>();

       Core_License__c cr=TestMethodUtility.createCoreLicense();
       cr.Name='Learn';
       crr.add(cr);

       Core_License__c cr1=TestMethodUtility.createCoreLicense();
       cr1.Name='Moodlerooms';
       crr.add(cr1);

       Core_License__c cr2=TestMethodUtility.createCoreLicense();
       cr2.Name='Collaborate';
       crr.add(cr2);

       Core_License__c cr3=TestMethodUtility.createCoreLicense();
       cr3.Name='Analytics';
       crr.add(cr3);
       
       insert crr;
       
       List<Asset> assetlist = new List<Asset>();

       Asset a = TestMethodUtility.createAsset(acc,cr);
       a.Name = 'testasset';
       a.Contact = con;
       a.Status = 'Installed';
       a.version__c = 'test';
       a.version_build__c='test';
       assetlist.add(a);

       Asset a1 = TestMethodUtility.createAsset(acc,cr1);
       a1.Name = 'testasset';
       a1.Contact = con;
       a1.Status = 'Installed';
       a1.version__c = 'test';
       a1.version_build__c='test';
       assetlist.add(a1);

       Asset a2 = TestMethodUtility.createAsset(acc,cr2);
       a2.Name = 'testasset';
       a2.Contact = con;
       a2.Status = 'Installed';
       a2.version__c = 'test';
       a2.version_build__c='test';
       assetlist.add(a2);

       Asset a3 = TestMethodUtility.createAsset(acc,cr3);
       a3.Name = 'testasset';
       a3.Contact = con;
       a3.Status = 'Installed';
       a3.version__c = 'test';
       a3.version_build__c='test';
       assetlist.add(a3);
      
       insert assetlist;

       List<Module__c> mod = new List<Module__c>();

       Module__c m = TestMethodUtility.createModule(cr);
       mod.add(m);

       Module__c m1 = TestMethodUtility.createModule(cr1);
       mod.add(m1);

       Module__c m2 = TestMethodUtility.createModule(cr2);
       mod.add(m2);

       Module__c m3 = TestMethodUtility.createModule(cr3);
       mod.add(m3);

       insert mod;

       list<case> caselist= new list<case>();

       Case c = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = a.Id, Core_License__c = cr.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
       caselist.add(c);

       Case c1 = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = a1.Id, Core_License__c = cr1.Id,Module__c = m1.Id,Status = 'New',Case_Severity__c = '1');
       caselist.add(c1);

       Case c2 = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = a2.Id, Core_License__c = cr2.Id,Module__c = m2.Id,Status = 'New',Case_Severity__c = '1');
       caselist.add(c2);

       Case c3 = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = a3.Id, Core_License__c = cr3.Id,Module__c = m3.Id,Status = 'New',Case_Severity__c = '1');
       caselist.add(c3);

       insert caselist;
       
       List<learnJIRA__c> Silist = new List<learnJIRA__c>();

       learnJIRA__c si = TestMethodUtility.createSupportIncident(c);
       Silist.add(si);

       learnJIRA__c si1 = TestMethodUtility.createSupportIncident(c1);
       Silist.add(si1);

       learnJIRA__c si2 = TestMethodUtility.createSupportIncident(c2);
       Silist.add(si2);

       learnJIRA__c si3 = TestMethodUtility.createSupportIncident(c3);
       Silist.add(si3);

       insert Silist;

       PageReference pageRef = Page.CreateSupportIncident;
       pageRef.getParameters().put('cid',c.Id);
       ApexPages.StandardController stdController = new ApexPages.StandardController(si);
       CreateSupportIncidentController ctr = new CreateSupportIncidentController(stdController);
       ctr.doSave();
       ctr.doCancel();

       pageRef = Page.CreateSupportIncident;
       pageRef.getParameters().put('cid',c3.Id);
       Test.setCurrentPageReference(pageRef);

       stdController = new ApexPages.StandardController(si3);
       ctr = new CreateSupportIncidentController(stdController);
       
       ctr.supportIncident.Summary__c = 'Test';
       ctr.supportIncident.Tier_2_Assessment__c = 'Test';
       ctr.supportIncident.Type__c = 'Test';
       ctr.supportIncident.Reproduced__c ='Test';
       ctr.doSave();
       ctr.doCancel();

     } 
     static testmethod void CreateSupportIncidentControllerTestSI3()
     {

     user systemuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     List<Version_Build_Tree__c> VersionBuildTree= (List<Version_Build_Tree__c>) System.Test.loadData(Version_Build_Tree__c.sObjectType, 'Test_VersionBuildTree');

     system.runas(systemuser)
     { 
       Account acc = TestMethodUtility.createAccount();
       insert acc;

       Contact con = TestMethodUtility.createContact(acc);
       insert con;

       Core_License__c cr = new  Core_License__c();
       cr.Name = 'Learn';
       insert cr; 

       Module__c m = TestMethodUtility.createModule(cr);
       insert m; 

       product2 prod = TestMethodUtility.createProduct();
       prod.GKEY_Product_Group__c='BB-LS';
       insert prod;

       Asset aset = TestMethodUtility.createAsset(acc,cr);
       aset.Product2Id = prod.Id;
       aset.Version__c = '9.2';
       aset.Version_Build__c = '9.1.110';
       insert aset;

       Case ca = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = aset.Id, Core_License__c = cr.Id,Version_on_Case__c = '9.2',Source_Build_on_Case__c = '9.1.110',Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
        insert ca;

      test.starttest();

       learnJIRA__c si = new learnJIRA__c();

       PageReference pg = Page.createsupportIncident;
       Test.setCurrentPage(pg);
       pg.getparameters().put('cid',ca.id);

       
       ApexPages.StandardController stdController = new ApexPages.StandardController(si);
       CreateSupportIncidentController ctr = new CreateSupportIncidentController(stdController);

       ctr.supportIncident.Summary__c = 'Test';
       ctr.supportIncident.Tier_2_Assessment__c = 'Test';
       ctr.supportIncident.Issue_Segment__c = 'Test';
       
       list<selectoption> versions = ctr.versions;
       ctr.version = versions[1].getvalue();

       list<selectoption> sblist = ctr.sblist;
       ctr.jirasourcebuild = sblist[1].getvalue();
       
       ctr.doSave();
       ctr.clearsb();

       test.stoptest();
        
       }
     }
   }