@isTest
public with sharing class BBW_ChangeAccounttest {
	
	static testmethod void BBW_ChangeAccounttest(){
  
    Profile p =[Select id,Name from profile where Name='System Administrator'];
    
    User u=TestMethodUtility.createUser(p);
    insert u;
    
    Account ac = TestMethodUtility.createAccount(); 
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac); 
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.PS_Person_Id__c='962729';
    insert c1;
    
    Core_License__c cr =TestMethodUtility.createCoreLicense();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset =TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
    
    List<case> Lcas = New List<Case>();
        
    Case cassoftsol =TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol.ContactID = c1.ID;
    //insert cassoftsol;
    Lcas.add(cassoftsol);
    
    Case cassoftsol1 =TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol1.ContactID = c1.ID;
    cassoftsol1.accountid=Null;
    //insert cassoftsol1;
    Lcas.add(cassoftsol1);
    
    Case cassoftsol2 =TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol2.ContactID = c1.ID;
    cassoftsol2.AssetId=Null;
    //insert cassoftsol2;
    Lcas.add(cassoftsol2);
    
    Case cassoftsol3 =TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol3.ContactID = c1.ID;
    cassoftsol3.module__c=Null;
    //insert cassoftsol3;
    Lcas.add(cassoftsol3);
    
    Case cassoftsol4 =TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol4.ContactID = Null;
    //insert cassoftsol4;
    Lcas.add(cassoftsol4);
    Insert Lcas;
    
    Module__c m =TestMethodUtility.createModule(cr);
    m.Name = 'MH Request';    
    insert m;
    
    Functional_Area__c f =TestMethodUtility.createFunctionalArea(m);
    f.Name = 'Upgrades'; 
    insert f;
    
    Category__c catg =TestMethodUtility.createCategory(f);
    catg.Functional_Area__c=f.id;
    insert catg;
    
   Contact_Role__c crole =TestMethodUtility.createContactRole(ac);
   crole.role__c='TRANSACT - Admin';
   crole.contact__c=c1.id;
   insert crole;
     
    System.Runas(u)
    {
 
    ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
    BBW_ChangeAccount ca = new BBW_ChangeAccount(controller);
    ca.errorTitle = null;
    ca.errorMessage = null;
    ca.errorSeverity = '1';
    ca.closeWin = false;
    ca.acc = ac;
    ca.ContactId = c1.ID;
    ca.asset = aset.ID;
    ca.version = '9.1';
    ca.module = m.ID;
    ca.functionalarea = f.ID;
    
    List<SelectOption> con =ca.contacts; 
    
    List<SelectOption> ast = ca.assets;
    
    List<SelectOption> ver = ca.versions;
    
    List<SelectOption> mod = ca.modules;
    
    List<SelectOption> fa = ca.functionalareas;
        
    //List<SelectOption> cat = ca.categories;
    
    List<SelectOption> sb = ca.sblist;
    
    ca.InstanceDisplay();
    ca.save();
    ca.getRecordTypeId();
    
    ca.previouscontacts();
    

    
    ApexPages.currentPage().getparameters().put('id',cassoftsol1.ID);
    ApexPages.StandardController controller1 = new ApexPages.StandardController(cassoftsol1);
    BBW_ChangeAccount ca1 = new BBW_ChangeAccount(controller1);
    ca1.save();
    
    ApexPages.currentPage().getparameters().put('id',cassoftsol2.ID);
    ApexPages.StandardController controller2 = new ApexPages.StandardController(cassoftsol2);
    BBW_ChangeAccount ca2 = new BBW_ChangeAccount(controller2);
    ca2.save();
    Test.StartTest();
    
    ApexPages.currentPage().getparameters().put('id',cassoftsol3.ID);
    ApexPages.StandardController controller3 = new ApexPages.StandardController(cassoftsol3);
    BBW_ChangeAccount ca3 = new BBW_ChangeAccount(controller3);
    ca3.save();
    
    ApexPages.currentPage().getparameters().put('id',cassoftsol4.ID);
    ApexPages.StandardController controller4 = new ApexPages.StandardController(cassoftsol4);
    BBW_ChangeAccount ca4 = new BBW_ChangeAccount(controller4);
    ca4.save();
    
    Test.StopTest();
    }
    }
    static testmethod void xpLorunittest()
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

        Asset aset = new Asset();
        aset.Name = 'Test Asset xpLor 1111';
        aset.Core_License__c = cr2.ID;
        aset.AccountID = ac.ID;
        aset.Installed_Product_ID__c = '123578axp';
        aset.Status = 'Installed'; 
        aset.Force_Btbb_Visibility__c=true;
        aset.Product2Id=product.id;
        insert aset;

        Module__c m = new Module__c();
        m.Name = 'Channels';
        m.Core_Licence__c = cr2.ID;    
        insert m;
         
        id xpLorrecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('xpLor').getRecordTypeId(); 

        case xplorcase = new case();
        xplorcase.AccountId = ac.Id;
        xplorcase.ContactId = c1.Id;
        xplorcase.AssetId = aset2.Id;
        xplorcase.Module__c = m.Id; 
        xplorcase.Core_License__c = cr2.Id;
        xplorcase.Course_ID__c = 'test';
        xplorcase.Site_URL__c = 'test';
        xplorcase.CMS_LMS__c = 'other';
        xplorcase.Subject = 'subject';
        xplorcase.Description = 'description';
        xplorcase.Steps_to_Replicate__c = 'steps to replicate';
        xplorcase.Status = 'New';
        xplorcase.Case_Severity__c = '3';
        xplorcase.recordtypeid = xpLorrecordtypeid;
        insert xplorcase;    
        
        test.starttest(); 

        ApexPages.currentPage().getparameters().put('id',xplorcase.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(xplorcase);
        BBW_ChangeAccount obj = new BBW_ChangeAccount(controller);
        
        obj.errorTitle = null;
        obj.errorMessage = null;
        obj.errorSeverity = '1';
        obj.closeWin = false;
        obj.acc = ac;
        obj.ContactId = c1.ID;
        obj.asset = aset2.ID;
        obj.module = m.ID;
 
         list<selectoption> assetoptions=obj.assets;
            
          obj.InstanceDisplay();
          obj.asset=aset.id;
          list<selectoption> modules=obj.modules;
          obj.module=m.id;  
          obj.cas.Site_URL__c = 'test';
          obj.cas.CMS_LMS__c = 'BLACKBOARD ANGEL';
          obj.cas.subject='testsubject';
          obj.cas.description='test description';
          obj.cas.Steps_to_Replicate__c='test';
          obj.save();

      }  
    }
}