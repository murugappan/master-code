@isTest
private class convert_endusercasetest {
	
	@isTest static void test_method_one() {
  
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

    product2 prod= Testmethodutility.createProduct();
    prod.GKEY_Product_Group__c='Test123';
    insert prod;
    Asset aset =TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    aset.Force_Btbb_Visibility__c=true;
    aset.Core_License__c=cr.id;
    aset.product2id=prod.id;
    insert aset;
    
    list <Version_Build_Tree__c> verlist= new list<version_build_tree__c>();
    Version_Build_Tree__c ver1 = new Version_Build_Tree__c(version__c='9.1',Version_Build__c='9.1.2',GKEY_Product_Group__c='Test123',Active_Flag__c = true);
    verlist.add(ver1);
    Version_Build_Tree__c ver2 = new Version_Build_Tree__c(version__c='9.1',Version_Build__c='9.1.1',GKEY_Product_Group__c='Test123',Active_Flag__c = true);
    verlist.add(ver2);
      Version_Build_Tree__c ver3 = new Version_Build_Tree__c(version__c='9.2',Version_Build__c='9.2.2',GKEY_Product_Group__c='Test123',Active_Flag__c = true);
      verlist.add(ver3);
    Version_Build_Tree__c ver4 = new Version_Build_Tree__c(version__c='9.2',Version_Build__c='9.2.1',GKEY_Product_Group__c='Test123',Active_Flag__c = true);
    verlist.add(ver4);
    insert verlist;

    List<case> Lcas = New List<Case>();
        
    Case cassoftsol =TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Core_License__c=cr.id;
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
    convert_endusercase ca = new convert_endusercase(controller);
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
    ca.getcategories();
    ca.InstanceDisplay();
    ca.save();
    ca.getRecordTypeId();

    ca.asset=null;
    ast = ca.modules;
    ca.nextcontacts();
    ca.previouscontacts();
    ca.InstanceDisplay();
    ApexPages.currentPage().getparameters().put('id',cassoftsol1.ID);
    ApexPages.StandardController controller1 = new ApexPages.StandardController(cassoftsol1);
    convert_endusercase ca1 = new convert_endusercase(controller1);
    ca1.save();
    
    ApexPages.currentPage().getparameters().put('id',cassoftsol2.ID);
    ApexPages.StandardController controller2 = new ApexPages.StandardController(cassoftsol2);
    convert_endusercase ca2 = new convert_endusercase(controller2);
    ca2.save();
    Test.StartTest();
    
    ApexPages.currentPage().getparameters().put('id',cassoftsol3.ID);
    ApexPages.StandardController controller3 = new ApexPages.StandardController(cassoftsol3);
    convert_endusercase ca3 = new convert_endusercase(controller3);
    ca3.save();
    
    ApexPages.currentPage().getparameters().put('id',cassoftsol4.ID);
    ApexPages.StandardController controller4 = new ApexPages.StandardController(cassoftsol4);
    convert_endusercase ca4 = new convert_endusercase(controller4);
    ca4.save();
    
    Test.StopTest();
    }
    
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}