@isTest
public  without sharing class btbbCreateCasetest {

 
        static testMethod void myUnitTest() {
        Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
        ac.BillingPostalCode = 'Testing Code';
        ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';

        insert ac;

        Contact c1 = new Contact();
        c1.FirstName = 'Test1';
        c1.LastName = 'Contact1';
        c1.Email = 'test@test1.com';
        c1.AccountID = ac.ID;

        insert c1;

        //List of core license
        List<Core_License__c> Lcore = New List<Core_License__c>();
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Xythos';
        //insert cr;    
        
        Core_License__c cr2 = new  Core_License__c();
        cr.Name = 'Moodlerooms';
        //insert cr2;  
        
        Lcore.add(cr);
        Lcore.add(cr2);
        Insert Lcore;
        
        
        // List of assets
        List<Asset> Last = New List<asset>();
      
        Asset aset = new Asset();
        aset.Name = 'Test Asset 111';
        aset.Core_License__c = cr.ID;
        aset.AccountID = ac.ID;
        aset.Installed_Product_ID__c = '123';
        aset.Status = 'Installed'; 
        aset.version__c = '9.1';
        aset.Psft_Product_Id__c = 'AS-LS';
        aset.Version_Build__c = '9.1.X';
      //  insert aset;

        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = cr2.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578MR';
        aset2.Status = 'Installed'; 
        aset2.version__c = '9.1';
        aset2.Psft_Product_Id__c = 'AS-LS-MR34';
        aset2.Version_Build__c = '9.1.X';
        aset2.Software_URL__c='www.mr.com';
       // insert aset2;
       
       Last.add(aset);
       Last.add(aset2);
       
       Insert Last;
       
        
        // List of casees
        List<case> Lcase = New List<case>();
        Case cassoftsol = new Case();        //for angel software solutions
        cassoftsol.AccountID = ac.ID;
        cassoftsol.ContactID = c1.ID;
        cassoftsol.Case_Severity__c = '1';
        cassoftsol.Subject = 'test';
        cassoftsol.Description = 'test';
        cassoftsol.assetID = aset.ID;
       // insert cassoftsol;

      Case MRcase = new Case();        //for angel software solutions
        MRcase.AccountID = ac.ID;
        MRcase.ContactID = c1.ID;
        MRcase.Case_Severity__c = '1';
        MRcase.Subject = 'test';
        MRcase.Description = 'test';
        MRcase.assetID = aset2.ID;
       // insert MRcase;
       
       Lcase.add(cassoftsol);
       Lcase.add(MRcase);
       Insert Lcase;
        
        Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;

       

        ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
        btbbcreatecase  ca = new btbbcreatecase(controller);
        ca.errorTitle = null;
        ca.errorMessage = null;
        ca.errorSeverity = '1';
        ca.asset = aset.ID;
        ca.version = '9.1';
        ca.module = m.ID;
        ca.functionalarea = f.ID;


        List<SelectOption> ast = new List<SelectOption>();
        ast  = ca.assets;

        List<SelectOption> ver = new List<SelectOption>();
        ver = ca.versions;

        List<SelectOption> mod = new List<SelectOption>();
        mod = ca.modules;

        List<SelectOption> fa = new List<SelectOption>();
        fa = ca.functionalareas;

        List<SelectOption> cat = new List<SelectOption>();
        cat = ca.categories;

        List<SelectOption> sb = new List<SelectOption>();
        sb = ca.sblist;

        ca.sourcebuild  = '9.1.1';
        ca.getdisplayInstance();
        ca.save();

        ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(cassoftsol);
        btbbcreatecase  ca1 = new btbbcreatecase(controller1);
        ca1.errorTitle = null;
        ca1.errorMessage = null;
        ca1.errorSeverity = '1';
        ca1.asset = aset.ID;
        ca1.version = '9.1';
        ca1.module = null;
        ca1.Save();

        ca1.asset=null;
        ca1.Save();

        ca1.contact = null;
        ca1.Save();

 Test.StartTest();
        ca1.Save();
        Case cassoftsol4 = new Case();        //for angel software solutions
        cassoftsol4.AccountID = ac.ID;
        cassoftsol4.ContactID = c1.ID;
        cassoftsol4.Case_Severity__c = '1';
        //  cassoftsol4.Subject = 'test';
        cassoftsol4.Module__c=m.id;
        cassoftsol4.Description = 'test';
        cassoftsol4.assetID = aset.ID;
        insert cassoftsol4; 
        Case cassoftsol5 = new Case();        //for angel software solutions
        cassoftsol5.AccountID = ac.ID;
        cassoftsol5.ContactID = c1.ID;
        cassoftsol5.Case_Severity__c = '1';
        cassoftsol5.Subject = 'test';
        cassoftsol5.Module__c=m.id;
        // cassoftsol4.Description = 'test';
        cassoftsol5.assetID = aset.ID;
        insert cassoftsol5; 
        Case cassoftsol6 = new Case();        //for angel software solutions
        cassoftsol6.AccountID = ac.ID;
        cassoftsol6.ContactID = c1.ID;
        //cassoftsol6.Case_Severity__c = '1';
        cassoftsol6.Subject = 'test';
        cassoftsol6.Module__c=m.id;
        cassoftsol6.Description = 'test';
        cassoftsol6.assetID = aset.ID;
        insert cassoftsol6; 

        ApexPages.currentPage().getparameters().put('id',cassoftsol4.ID);
        ApexPages.StandardController controller4 = new ApexPages.StandardController(cassoftsol4);
        btbbcreatecase ca4 = new btbbcreatecase(controller4); 
        ca4.save();  
        ApexPages.currentPage().getparameters().put('id',cassoftsol5.ID);
        ApexPages.StandardController controller5 = new ApexPages.StandardController(cassoftsol5);
        btbbcreatecase ca5 = new btbbcreatecase(controller5); 
        ca5.save();

        ApexPages.currentPage().getparameters().put('id',cassoftsol6.ID);
        ApexPages.StandardController controller6 = new ApexPages.StandardController(cassoftsol6);
        btbbcreatecase ca6 = new btbbcreatecase(controller6); 
        ca6.save();

        
        list<selectoption>accounts=ca6.accounts;
        ca6.getclos();
        ca6.getbrowsop();
        ca6.getSeverities();
        ca6.getmrcsop();
        ca6.redirect();
        ca6.selectAccount();
        ca6.asset=cassoftsol6.assetID;
        ca6.selectAsset();
        test.stoptest();
        ca6.updateasset();
        ca6.Cancel();
        ca6.getpremiumsupport1();
        ca6.cancelupdate();
        ca6.changeEdit();
        ca6.versions=accounts;
        ca6.changeEdit();
        ca6.changeversion();
        ca6.modulechange();
        ca6.getsev();
       
    }
    
 static testMethod void myMRTest2() {
        Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
        ac.BillingPostalCode = 'Testing Code';
        ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';

        insert ac;

        Contact c1 = new Contact();
        c1.FirstName = 'Test1';
        c1.LastName = 'Contact1';
        c1.Email = 'test@test1.com';
        c1.AccountID = ac.ID;
        insert c1;
   
        Core_License__c cr2 = new  Core_License__c();
        cr2.Name = 'Moodlerooms';
        insert cr2; 
        
        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = cr2.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578MR';
        aset2.Status = 'Installed'; 
        aset2.version__c = '9.1';
        aset2.Psft_Product_Id__c = 'AS-LS-MR34';
        aset2.Version_Build__c = '9.1.X';
        aset2.Software_URL__c='www.mr.com';
        insert aset2;
        
        Case MRcase = new Case();        //for angel software solutions
        MRcase.AccountID = ac.ID;
        MRcase.ContactID = c1.ID;
        MRcase.Case_Severity__c = '1';
        MRcase.Subject = 'test';
        MRcase.Description = 'test';
        MRcase.assetID = aset2.ID;
        insert MRcase;
        
         Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr2.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;
        
        test.starttest(); 
         ApexPages.currentPage().getparameters().put('id',MRcase.ID);
        ApexPages.StandardController controller7 = new ApexPages.StandardController(MRcase);
        btbbcreatecase ca7 = new btbbcreatecase(controller7); 
        ca7.asset=MRcase.assetID;
        ca7.getdisplayinstance();
        ca7.cas.accountid=MRcase.accountid;
        ca7.contact=MrCase.contactid;
        ca7.module=m.id;
        ca7.cas.subject=null;
        ca7.save();
        ca7.cas.subject='Test for MR';
        ca7.save();
        ca7.cas.Description=null;
        ca7.save();
        Test.stopTest();
        ca7.cas.Description='Test';
        ca7.save();
        ca7.cas.URL_Access__c=Null;
        ca7.save();
        ca7.cas.URL_Access__c='test';
        ca7.save();
        ca7.mrcasetypevalues=null;
        ca7.save();
        ca7.mrcasetypevalues='Installed';
        ca7.save();
    }      


     static testMethod void Analyticstestcase() {
    user systemuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
   
        
        List<Version_Build_Tree__c> VersionBuildTree= (List<Version_Build_Tree__c>) System.Test.loadData(Version_Build_Tree__c.sObjectType, 'Test_VersionBuildTree');
     system.runas(systemuser)  
    {    
        product2 product= TestMethodUtility.createProduct();
        product.GKEY_Product_Group__c='AN-AD';
        insert product;

        Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
        ac.BillingPostalCode = 'Testing Code';
        ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';

        insert ac;

        Contact c1 = new Contact();
        c1.FirstName = 'Test1';
        c1.LastName = 'Contact1';
        c1.Email = 'test@test1.com';
        c1.AccountID = ac.ID;
        c1.PS_Person_Id__c='67367332';
        insert c1;
        
        Contact_role__c contactRole= TestMethodUtility.createContactRole(ac);
        contactRole.Contact__c=c1.id;
        contactRole.Role__c='ANALYTICS - Admin';
        insert contactRole;

        Contact_role__c contactRole2= TestMethodUtility.createContactRole(ac);
        contactRole2.Contact__c=c1.id;
        contactRole2.Role__c='LEARN (Bb) - Admin';
        insert contactRole2;


        Core_License__c cr2 = new  Core_License__c();
        cr2.Name = 'Analytics';
        insert cr2; 
        
        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = cr2.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578MR';
        aset2.Status = 'Installed'; 
        aset2.version__c = '9.1';
        aset2.Psft_Product_Id__c = 'AS-LS-MR34';
        aset2.Version_Build__c = '9.1.X';
        aset2.Software_URL__c='www.mr.com';
        aset2.Force_Btbb_Visibility__c=true;
        aset2.Product2Id=product.id;
        insert aset2;
        aset2.Core_License__c = cr2.ID;
        update aset2;
        system.debug('Asset-->'+[select id,Core_License__c from asset where id=:aset2.id]);

         Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr2.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;
        
        profile p = [Select Id From Profile Where Name='SRV - BTBB User' limit 1];
        user u1= TestMethodUtility.createUser(p);
        u1.ContactId = c1.Id;
        u1.NOV_Preferred_Site__c='Learn';
        insert u1; 
        

        test.starttest(); 
        system.runas(u1)
        {
        case newcase= new case();
        ApexPages.StandardController controller = new ApexPages.StandardController(newcase);
        btbbcreatecase obj = new btbbcreatecase(controller); 
        list<selectoption> accountoptions=obj.accounts;
        obj.account=ac.id;
        system.debug('ac-->'+obj.account);
        system.debug('acs-->'+accountoptions);
        obj.selectAccount();
        list<selectoption> assetoptions=obj.assets;
        obj.asset=aset2.id;
         system.debug('asset-->'+obj.asset);
          system.debug('assets-->'+assetoptions);  
        obj.selectAsset();
        list<selectoption> versions=obj.versions;
        obj.version=versions[1].getvalue();
        obj.changeedit();
        list<selectoption> sblist=obj.sblist;
        obj.sourcebuild=sblist[1].getvalue();
        obj.changeversion();
        list<selectoption> modules=obj.modules;
        obj.module=m.id;
        obj.modulechange();
        obj.module=m.id;
        list<selectoption> functionalareas=obj.functionalareas;
        obj.functionalarea=f.id;
        obj.cas.subject='testsubject';
        obj.cas.description='test description';
        obj.cas.Steps_to_Replicate__c='test';
        boolean managedhostingasset = obj.managedhostingasset;
        obj.save();

        ///Test for picklists:
        obj.getcmsoptions();
        obj.getinstanceoptions();
        obj.getusrroleoptions();
        obj.getSeverities();
       }
     }   
    }
    static testMethod void xplortestcase()
    {
       user systemuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1]; 
       system.runas(systemuser)
       {
         
        product2 product= TestMethodUtility.createProduct();
        product.GKEY_Product_Group__c='XPLOR';
        insert product;

        Account ac = TestMethodUtility.createAccount();
        ac.xpLor_Queue__c = 'Moodlerooms: Territory 1 Engagement Team';
        insert ac;

        Contact c1 = new Contact();
        c1.FirstName = 'Test1';
        c1.LastName = 'Contact1';
        c1.Email = 'test@test1.com';
        c1.AccountID = ac.ID;
        c1.PS_Person_Id__c='673673322';
        insert c1;
        
        Contact_role__c contactRole= TestMethodUtility.createContactRole(ac);
        contactRole.Contact__c=c1.id;
        contactRole.Role__c='XPLOR - Admin';
        insert contactRole;

        Contact_role__c contactRole2= TestMethodUtility.createContactRole(ac);
        contactRole2.Contact__c=c1.id;
        contactRole2.Role__c='LEARN (Bb) - Admin';
        insert contactRole2;


        Core_License__c cr2 = new  Core_License__c();
        cr2.Name = 'xpLor';
        insert cr2; 
        
        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset xpLor 111';
        aset2.Core_License__c = cr2.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578xp';
        aset2.Status = 'Installed'; 
        aset2.Force_Btbb_Visibility__c=true;
        aset2.Product2Id=product.id;
        insert aset2;

        Module__c m = new Module__c();
        m.Name = 'Channels';
        m.Core_Licence__c = cr2.ID;    
        insert m;

        profile p = [Select Id From Profile Where Name='SRV - BTBB User' limit 1];
        user u1= TestMethodUtility.createUser(p);
        u1.ContactId = c1.Id;
        u1.NOV_Preferred_Site__c='Learn';
        insert u1; 
        

        test.starttest(); 
        system.runas(u1)
        {
          case newcase= new case();
          ApexPages.StandardController controller = new ApexPages.StandardController(newcase);
          btbbcreatecase obj = new btbbcreatecase(controller); 
          list<selectoption> accountoptions=obj.accounts;
          obj.account=ac.id;
          obj.selectAccount();
          list<selectoption> assetoptions=obj.assets;
          obj.asset=aset2.id;  
          obj.selectAsset();  
          list<selectoption> modules=obj.modules;
          obj.module=m.id;
          obj.modulechange();
          obj.module=m.id;
          
          obj.cas.Site_URL__c = 'test';
          obj.cmsvalue = 'test';
          obj.cas.subject='testsubject';
          obj.cas.description='test description';
          obj.cas.Steps_to_Replicate__c='test';
          obj.save();

          obj.getcmsoptions();
          
        }
      }  
    }


}