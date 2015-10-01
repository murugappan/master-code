@istest
private class btbbSubscriptionsControllerExtensionTest {
	
	 static testmethod void btbbSubcriptionsControllerExtensiontest(){
    
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
    
    insert c1;
    
    Core_License__c cr = TestMethodUtility.createCoreLicense();
    cr.Name = 'ANGEL';
    insert cr; 
    
    Module__c m1 =TestMethodUtility.createModule(cr);
    m1.Name = 'ICM Support';
    m1.Core_Licence__c = cr.ID;
    insert m1;
    
    Functional_Area__c f = TestMethodUtility.createFunctionalArea(m1);
    f.Name = 'Upgrades';
    f.Module__c = m1.ID;
    insert f;
    
    Category__c cc = TestMethodUtility.createCategory(f);
    cc.CurrencyIsoCode='GBP';
    cc.Functional_Area__c=f.id;
    insert cc;
    
    
   
    
    Asset aset =TestMethodUtility.createAsset(ac,cr);
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
        
    Case cassoftsol = TestMethodUtility.createCase1(ac,aset);        //for angel software solutions
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    insert cassoftsol;
    
    Profile pf2= [select id from Profile where name = 'BTBB Profile'];
       
    User u3 =TestMethodUtility.createUser(pf2);
        
    insert u3; 
    
    CategoryNode cn1 = [select id from CategoryNode where MasterLabel='Learn' limit 1]; 
    CategoryNode cn2 = [select id from CategoryNode where MasterLabel='CE/Vista'limit 1]; 
    CategoryNode cn3 = [select id from CategoryNode where MasterLabel='Xythos' limit 1]; 
    CategoryNode cn4 = [select id from CategoryNode where MasterLabel='Mobile'limit 1]; 
    
    System.runas(u3)
     {
		    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
		    btbbSubcriptionsControllerExtension sc = new btbbSubcriptionsControllerExtension(controller); 
		    sc.getUserContactId();
		    sc.getUserId();
		    sc.SelectCategory();
		   list<selectoption> cat_options= sc.getCategories();
		    sc.getArticleCategories();
		   
     }
    }

}