/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.test
 */
@istest(seealldata=True)
private class createcasetest {

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

        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Xythos';
        insert cr;    
        
        Core_License__c cr2 = new  Core_License__c();
        cr.Name = 'Moodlerooms';
        insert cr2;  
        product2 prod=[select id,GKEY_Product_Group__c  from product2 where GKEY_Product_Group__c != null and isactive=true limit 1] ;

        Asset aset = new Asset();
        aset.Name = 'Test Asset 111';
        aset.Core_License__c = cr.ID;
        aset.AccountID = ac.ID;
        aset.Installed_Product_ID__c = '1244443';
        aset.Status = 'Installed'; 
        aset.version__c = '9.1';
        aset.Psft_Product_Id__c = 'AS-LS';
        aset.Version_Build__c = '9.1.X';
        aset.product2id=prod.id;
        insert aset;

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
        aset2.product2id=prod.id;
        insert aset2;
        
        Case cassoftsol = new Case();        //for angel software solutions
        cassoftsol.AccountID = ac.ID;
        cassoftsol.ContactID = c1.ID;
        cassoftsol.Case_Severity__c = '1';
        cassoftsol.Subject = 'test';
        cassoftsol.Description = 'test';
        cassoftsol.assetID = aset.ID;
        insert cassoftsol;

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
        m.Core_Licence__c = cr.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;
				
        Test.StartTest();

        ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
        createCase  ca = new createCase(controller);
        ca.errorTitle = null;
        ca.errorMessage = null;
        ca.errorSeverity = '1';
        ca.AccountId = ac.ID;
        ca.ContactId = c1.ID;
        ca.asset = aset.ID;
        ca.version = '9.1';
        ca.module = m.ID;
        ca.functionalarea = f.ID;
        ca.compare = 'Angel';
        ca.temp_flag = true;

        version_build_tree__c vr1=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.110',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr1;
        version_build_tree__c vr2=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.220',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr2;
        version_build_tree__c vr3=new version_build_tree__c(Version__c='9.2',Version_Build__c='10.2.220',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr3;

        List<SelectOption> con = new List<SelectOption>();
        con  = ca.contacts;

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
        ca.InstanceDisplay();
        ca.save();
        
        ca.clearsb();
        ca.getRecordTypeId();
        //ca.saveandgrab(); 

        ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(cassoftsol);
        createCase  ca1 = new createCase(controller1);
        ca1.errorTitle = null;
        ca1.errorMessage = null;
        ca1.errorSeverity = '1';
        ca1.compare = 'Angel';
        ca1.temp_flag = true;
        ca1.AccountId = ac.ID;
        ca1.ContactId = c1.ID;
        ca1.asset = aset.ID;
        ca1.version = '9.1';
        ca1.module = null;
        ca1.Save();
        

        ca1.asset=null;
        ca1.Save();
        

        ca1.contact = null;
        ca1.Save();
        

        ca1.AccountId = null;
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
        createCase ca4 = new createCase(controller4); 
        ca4.save(); 
        
         
        ApexPages.currentPage().getparameters().put('id',cassoftsol5.ID);
        ApexPages.StandardController controller5 = new ApexPages.StandardController(cassoftsol5);
        createCase ca5 = new createCase(controller5); 
        ca5.save();
        

        ApexPages.currentPage().getparameters().put('id',cassoftsol6.ID);
        ApexPages.StandardController controller6 = new ApexPages.StandardController(cassoftsol6);
        createCase ca6 = new createCase(controller6); 
        ca6.save();
        
        test.stoptest();
        
       
        ca6.getclos();
        ca6.getbrowsop();
        ca6.getSeverityLevelop();
        ca6.getmrcsop();
        ca6.nextcontacts();
        ca6.previouscontacts();
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
        createCase ca7 = new createCase(controller7); 
        ca7.asset=MRcase.assetID;
        ca7.instancedisplay();
        ca7.cas.accountid=MRcase.accountid;
        ca7.contact=MrCase.contactid;
        ca7.module=m.id;
        ca7.SeverityLevelvalues='3';
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
         ca7.ccemail='test1';
         ca7.save();
        ca7.ccemail='test1@abc.com;test2@abc.com;test3@abc.com;test5@abc.com;test4@abc.com';
        ca7.save();
        
    } 
     static testMethod void myUnitTest3() {
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

        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Xythos';
        insert cr;    
        
        Core_License__c cr2 = new  Core_License__c();
        cr.Name = 'Moodlerooms';
        insert cr2;  

        Asset aset = new Asset();
        aset.Name = 'Test Asset 111';
        aset.Core_License__c = cr.ID;
        aset.AccountID = ac.ID;
        aset.Installed_Product_ID__c = '123';
        aset.Status = 'Installed'; 
        aset.version__c = '9.1';
        aset.Psft_Product_Id__c = 'AS-LS';
        aset.Version_Build__c = '9.1.X';
        insert aset;

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
        
        Case cassoftsol = new Case();        //for angel software solutions
        cassoftsol.AccountID = ac.ID;
        cassoftsol.ContactID = c1.ID;
        cassoftsol.Case_Severity__c = '1';
        cassoftsol.Subject = 'test';
        cassoftsol.Description = 'test';
        cassoftsol.assetID = aset.ID;
        insert cassoftsol;

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
        m.Core_Licence__c = cr.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;

        Test.StartTest();

        ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
        createCase  ca = new createCase(controller);
        ca.errorTitle = null;
        ca.errorMessage = null;
        ca.errorSeverity = '1';
        ca.AccountId = ac.ID;
        ca.ContactId = c1.ID;
        ca.asset = aset.ID;
        ca.version = '9.1';
        ca.module = m.ID;
        ca.functionalarea = f.ID;

        List<SelectOption> con = new List<SelectOption>();
        con  = ca.contacts;

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
        ca.InstanceDisplay();
        //ca.save();
        ca.saveandgrab();
        ca.clearsb();
        ca.getRecordTypeId();
        //ca.saveandgrab(); 
		ca.getnextcontacts();
        ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(cassoftsol);
        createCase  ca1 = new createCase(controller1);
        ca1.errorTitle = null;
        ca1.errorMessage = null;
        ca1.errorSeverity = '1';
        ca1.AccountId = ac.ID;
        ca1.ContactId = c1.ID;
        ca1.asset = aset.ID;
        ca1.version = '9.1';
        ca1.module = null;
       // ca1.Save();
        ca1.saveandgrab();

        ca1.asset=null;
        //ca1.Save();
        ca1.saveandgrab();

        ca1.contact = null;
        //ca1.Save();
        ca1.saveandgrab();

        ca1.AccountId = null;
        //ca1.Save();
        ca1.saveandgrab();
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
        createCase ca4 = new createCase(controller4); 
        //ca4.save(); 
        ca4.saveandgrab();
         
        ApexPages.currentPage().getparameters().put('id',cassoftsol5.ID);
        ApexPages.StandardController controller5 = new ApexPages.StandardController(cassoftsol5);
        createCase ca5 = new createCase(controller5); 
        //ca5.save();
        ca5.saveandgrab();

        ApexPages.currentPage().getparameters().put('id',cassoftsol6.ID);
        ApexPages.StandardController controller6 = new ApexPages.StandardController(cassoftsol6);
        createCase ca6 = new createCase(controller6); 
        //ca6.save();
        ca6.saveandgrab();
        test.stoptest();
        
       
        ca6.getclos();
        ca6.getbrowsop();
        ca6.getSeverityLevelop();
        ca6.getmrcsop();
        ca6.nextcontacts();
        ca6.previouscontacts();
        ca6.getinstanceoptions();
        ca6.getcmsoptions();
        ca6.getusrroleoptions();
    }
static testMethod void myMRTest4() {
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
        
        cr2 = [select name, id from Core_License__c limit 1];
        string sname = cr2.name;
        System.debug('----'+ sname);
        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = cr2.ID;
        aset2.Force_Btbb_Visibility__c = true;
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
        
        Asset aset3 = new Asset();
        aset3.Name = 'Test Moodlerooms';
        aset3.Core_License__c = cr2.ID;
        aset3.Force_Btbb_Visibility__c = true;
        aset3.AccountID = MRcase.AccountID;
        aset3.Installed_Product_ID__c = '123578MR3';
        aset3.Status = 'Installed'; 
        aset3.version__c = '9.1';
        aset3.Psft_Product_Id__c = '123456';
        aset3.Version_Build__c = '9.1.X';
        aset3.Software_URL__c='www.mr.com';
        //aset3.Core_License__r.name = cr2.Name;
        insert aset3;
        
         Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr2.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;
        ChatCase__c cc = new ChatCase__c();
		cc.Account__c=ac.id;
		cc.Asset__c=aset2.id;
		cc.Browser__c='chrome';
		cc.Browser_Version__c='9';
		cc.Client_OS__c='windows';
		cc.Client_OS_Version__c='8';
		cc.CMS_LMS_URL__c='2';
        cc.Contact__c=c1.id;
        cc.description__c='test description';
        cc.Java_Version__c='7';
        cc.phone__c='9184613';
        cc.subject__c='test subject';
       insert cc;
      
        
        
        
        profile p=[select id,name from profile where name like '%SRV%' and name like '%administrator%' limit 1];
        user u = testmethodUtility.createUser(p);
        u.Primary_Group__c='Learn - L1';
        insert u;
        test.starttest(); 
          ApexPages.currentPage().getparameters().put('id',MRcase.ID);
         ApexPages.currentPage().getparameters().put('def_chatcase_id',cc.id);
         
        ApexPages.StandardController controller7 = new ApexPages.StandardController(MRcase);
        
        createCase ca7 = new createCase(controller7); 
        ca7.asset=MRcase.assetID;
        ca7.instancedisplay();
        ca7.cas.accountid=MRcase.accountid;
        ca7.contact=MrCase.contactid;
        ca7.module=m.id;
        ca7.SeverityLevelvalues='3';
        ca7.cas.subject=null;
        ca7.errorMessage =null;
        ca7.errortitle=null;
        //ca7.save();
        ca7.saveandgrab();
        ca7.cas.subject='Test for MR';
        //ca7.save();
        ca7.saveandgrab();
        ca7.cas.Description=null;
        //ca7.save();
        ca7.saveandgrab();
        Test.stopTest();
        ca7.cas.Description='Test';
        //ca7.save();
        ca7.saveandgrab();
        ca7.cas.URL_Access__c=Null;
       // ca7.save();
        ca7.saveandgrab();
        ca7.cas.URL_Access__c='test';
        //ca7.save();
        ca7.saveandgrab();
        ca7.mrcasetypevalues=null;
        //ca7.save();
        ca7.saveandgrab();
        ca7.mrcasetypevalues='Installed';
        //ca7.save();
       
        ca7.ccemail='test1';
       ca7.saveandgrab();
        ca7.ccemail='test1@abc.com;test2@abc.com;test3@abc.com;test5@abc.com;test4@abc.com';

        ca7.saveandgrab();
        system.runas(u)
        {
        ca7.saveandgrab();  
        }

    }
    static testMethod void Analyticscase()
    {
      Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';        
        ac.BillingPostalCode = 'Testing Code';
        ac.Angel_Queue__c = 'Analytics_L1';

        insert ac;

        Contact c1 = new Contact();
        c1.FirstName = 'Test1';
        c1.LastName = 'Contact1';
        c1.Email = 'test@test1.com';
        c1.AccountID = ac.ID;

        insert c1;

        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Analytics';
        insert cr;     

        Asset aset = new Asset();
        aset.Name = 'Test Asset 111';
        aset.Core_License__c = cr.ID;
        aset.AccountID = ac.ID;
        aset.Installed_Product_ID__c = '123';
        aset.Status = 'Installed'; 
        aset.version__c = '9.1';
        aset.Psft_Product_Id__c = 'AS-LS';
        aset.Version_Build__c = '9.1.X';
        insert aset;

        Case c = new Case(); 
        c.AccountID = ac.ID;
        c.ContactID = c1.ID;
        c.Case_Severity__c = '1';
        c.Subject = 'test';
        c.Description = 'test';
        c.assetID = aset.ID;
        insert c;
        
        Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;

        Test.StartTest();

        ApexPages.currentPage().getparameters().put('id',c.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        createCase  ca = new createCase(controller);
        ca.errorTitle = null;
        ca.errorMessage = null;
        ca.errorSeverity = '1';
        ca.AccountId = ac.ID;
        ca.ContactId = c1.ID;
        ca.asset = aset.ID;
        ca.version = '9.1';
        ca.module = m.ID;
        ca.functionalarea = f.ID;

        List<SelectOption> con = new List<SelectOption>();
        con  = ca.contacts;

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
        ca.InstanceDisplay();
        
        ca.saveandgrab();
        ca.clearsb();
        ca.getRecordTypeId();
        ca.getPyramidversions();  
        ca.getnextcontacts();
        
    } 
    static testMethod void LEARNSAAScase()
    {
      Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';        
        ac.BillingPostalCode = 'Testing Code';
        ac.Angel_Queue__c = 'Analytics_L1';

        insert ac;

        Contact c1 = new Contact();
        c1.FirstName = 'Test1';
        c1.LastName = 'Contact1';
        c1.Email = 'test@test1.com';
        c1.AccountID = ac.ID;

        insert c1;

        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Learn';
        cr.Product__c='Learn SAAS';
        insert cr;     

        Asset aset = new Asset();
        aset.Name = 'Test Asset 111';
        aset.Core_License__c = cr.ID;
        aset.AccountID = ac.ID;
        aset.Installed_Product_ID__c = '123';
        aset.Status = 'Installed'; 
        aset.version__c = '9.1';
        aset.Psft_Product_Id__c = 'AS-LS';
        aset.Version_Build__c = '9.1.X';
        aset.Force_Btbb_Visibility__c = true;
        insert aset;

        Case c = new Case(); 
        c.AccountID = ac.ID;
        c.ContactID = c1.ID;
        c.Case_Severity__c = '1';
        c.Subject = 'test';
        c.Description = 'test';
        c.assetID = aset.ID;
        insert c;
        
        Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr.ID;    
        insert m;

        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;

        Test.StartTest();

        ApexPages.currentPage().getparameters().put('id',c.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        createCase  ca = new createCase(controller);
        ca.errorTitle = null;
        ca.errorMessage = null;
        ca.errorSeverity = '1';
        ca.AccountId = ac.ID;
        ca.ContactId = c1.ID;
        ca.asset = aset.ID;
        ca.version = '9.1';
        ca.module = m.ID;
        ca.functionalarea = f.ID;

        List<SelectOption> con = new List<SelectOption>();
        con  = ca.contacts;

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
        ca.InstanceDisplay();
        
        ca.saveandgrab();
        ca.clearsb();
        ca.getRecordTypeId();
        ca.getPyramidversions();  
        ca.getnextcontacts();
        
    } 

    static testMethod void UnitTestxplorPositiveScenario()
    {
       user systemuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
        
       system.runas(systemuser)
       {
        Account ac = TestMethodUtility.createAccount();
        ac.xpLor_Queue__c = 'Moodlerooms: Territory 1 Engagement Team';
        insert ac;

        Contact c = TestMethodUtility.createContact(ac);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.PS_Person_Id__c='555666';
        c.Email = 'test@test.com';
        insert c;

        Contact_Role__c crr = new Contact_Role__c();
        crr.Account__c=ac.id;
        crr.Role__c = 'XPLOR - Admin';
        crr.Contact__c=c.id;
        insert crr;

        core_license__c cr = new Core_License__c();
        cr.Name = 'xpLor';
        insert cr;
        
        product2 product= TestMethodUtility.createProduct();
        product.name = 'test xplor product';
        product.BTBB_Product_Group__c='XPLOR';
        product.GKEY_Product_Group__c = 'XPLOR';
        insert product;

        Asset a = new Asset();
        a.Core_License__c = cr.Id;
        a.AccountId = ac.ID;
        a.name = 'xpLortest';
        a.Status = 'Installed';
        a.Force_Btbb_Visibility__c=true;
        a.Product2Id=product.id;
        insert a;

        Module__c m = new Module__c();
        m.Name = 'channels';
        m.Core_Licence__c = cr.ID;    
        insert m;

        Profile p = [select Id, Name from Profile where Name='SRV - System Administrator' limit 1];

        User u =TestMethodUtility.createUser(p);
        u.IsActive = true;
        Insert u;

        map<id,Schema.RecordTypeInfo> caserecodtypemap = Schema.SObjectType.Case.getRecordTypeInfosById();
             

        test.starttest(); 
        
          case newcase= new case(AccountID = ac.id);
          Test.setCurrentPage(Page.AssetOnCase);
          ApexPages.StandardController controller = new ApexPages.StandardController(newcase);
          createCase obj = new createCase(controller);

          list<selectoption> contacts = obj.contacts;
          obj.contact = c.id;

          list<selectoption> assetoptions=obj.assets;
          obj.asset=a.id;
          obj.InstanceDisplay();

          list<selectoption> modules=obj.modules;
          obj.module=m.id;
          
          list<selectoption> caseseverity = obj.getSeverityLevelop();
          obj.SeverityLevelvalues = '3';

          obj.cas.Core_License__c = a.Core_License__c;
          obj.cas.Site_URL__c = 'test';
          obj.cmsvalue = 'test';
          obj.cas.subject='testsubject';
          obj.cas.description='test description'; 

          obj.save();
          obj.saveandgrab();
          obj.getcmsoptions();
          obj.getSeverityLevelop();
    
        test.stoptest();
    
       }

    }
    static testMethod void UnitTestxplorNegativeScenario()
    {
       user systemuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
        
       system.runas(systemuser)
       {
        Account ac = TestMethodUtility.createAccount();
        ac.xpLor_Queue__c = 'Moodlerooms: Territory 1 Engagement Team';
        insert ac;

        Contact c = TestMethodUtility.createContact(ac);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.PS_Person_Id__c='555666';
        c.Email = 'test@test.com';
        insert c;

        core_license__c cr = new Core_License__c();
        cr.Name = 'xpLor';
        insert cr;
        
        product2 product= TestMethodUtility.createProduct();
        product.name = 'test xplor product';
        product.BTBB_Product_Group__c='XPLOR';
        product.GKEY_Product_Group__c = 'XPLOR';
        insert product;

        Asset a = new Asset();
        a.Core_License__c = cr.Id;
        a.AccountId = ac.ID;
        a.name = 'xpLortest';
        a.Status = 'Installed';
        a.Force_Btbb_Visibility__c=true;
        a.Product2Id=product.id;
        insert a;

        Module__c m = new Module__c();
        m.Name = 'channels';
        m.Core_Licence__c = cr.ID;    
        insert m;

        Profile p = [select Id, Name from Profile where Name='SRV - System Administrator' limit 1];

        User u =TestMethodUtility.createUser(p);
        u.IsActive = true;
        Insert u;

        test.starttest(); 
        
          case newcase= new case(AccountID = ac.id);
          Test.setCurrentPage(Page.AssetOnCase);
          ApexPages.StandardController controller = new ApexPages.StandardController(newcase);
          createCase obj = new createCase(controller);
          
          obj.errorTitle = null;
          obj.errorMessage = null;
          obj.errorSeverity = '1';

          list<selectoption> contacts = obj.contacts;
          obj.contact = c.id;

          list<selectoption> assetoptions=obj.assets;
          obj.asset=a.id;
          obj.InstanceDisplay();

          list<selectoption> modules=obj.modules;
          obj.module=m.id;
          
          list<selectoption> caseseverity = obj.getSeverityLevelop();
          obj.SeverityLevelvalues = '3';

          obj.cas.subject='testsubject';
          obj.cas.description='test description';
          obj.cas.Core_License__c = a.Core_License__c;
          obj.cas.Site_URL__c = '';
          obj.save();
          obj.cmsvalue = '';
          obj.save();
          

          obj.save();
          obj.saveandgrab();
          obj.getcmsoptions();
    
        test.stoptest();
    
       }

    }
     
}