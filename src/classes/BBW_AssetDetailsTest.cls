/*
 Test class for BBW_AssetDetails.
 Created date:-20.05.2013
*/
@isTest
private class BBW_AssetDetailsTest {

    static testMethod void myUnitTest() {
    
				//Account
				Account ac = TestMethodUtility.createAccount();
				ac.Name = 'Testing1 Account';
				ac.BillingStreet = 'Testing1 Street';
				ac.BillingCity = 'Testing1 City';
				ac.BillingState = 'Testing1 State';
				ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
				ac.BillingPostalCode = 'Testing Code';
				ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
                insert ac;
                
                //Contact
			    Contact c1 = TestMethodUtility.createContact(ac);
			    c1.FirstName = 'Test1';
			    c1.LastName = 'Contact1';
			    c1.Email = 'test@test1.com'; 
			    insert c1;
			    
			    //Core license
			    Core_License__c cr =TestMethodUtility.createCoreLicense();
			    cr.Name='Moodlerooms';
			    insert cr;
			    
               //Asset
			    Asset aset = TestMethodUtility.createAsset(ac,cr);
			    aset.Name = 'Test Asset 111';
			    aset.Installed_Product_ID__c = '123';
			    aset.Status = 'Installed'; 
			    aset.version__c = '9.1';
			    aset.Psft_Product_Id__c = 'AS-LS';
			    aset.Version_Build__c = '9.1.X';
			    insert aset;
			    
			    RecordType  rt =[select id from recordtype where SobjectType='Case' and Name='Moodlerooms'];
			    //insert case
			    Case cassoftsol = TestMethodUtility.createCase1(ac,aset);        //for angel software solutions
			    cassoftsol.AccountID = ac.ID;
			    cassoftsol.ContactID = c1.ID;
			    cassoftsol.Case_Severity__c = '1';
			    cassoftsol.Subject = 'test';
			    cassoftsol.Description = 'test';
			    cassoftsol.assetID  = aset.ID;
			    cassoftsol.RecordTypeid=rt.id;
			    insert cassoftsol;
			    
			    
			    ApexPages.currentPage().getParameters().put('id',cassoftsol.ID);
			    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
			    BBW_AssetDetails  ca = new BBW_AssetDetails(controller);
    }
}