/*
Class:Clone_Case
Date:21.05.2013
*/
@isTest
private class Clone_CaseTest {

    static testMethod void myUnitTest() {
        
        
        
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
    c1.AccountID = ac.ID;
    
    insert c1;
    
    Core_License__c cr = TestMethodUtility.createCoreLicense();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset = TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Core_License__c = cr.ID;
    aset.AccountID = ac.ID;
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
        
    Case cassoftsol = TestMethodUtility.createCase1(ac,aset);       //for angel software solutions
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset.ID;
    insert cassoftsol;
    
    Test.StartTest();
    ApexPages.CurrentPage().getParameters().put('id',cassoftsol.id);
    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
    Clone_Case cc = new Clone_Case(controller);
    cc.autoRun();
    cc.Cancel();
    ApexPages.CurrentPage().getParameters().put('id',null);
    cc.autoRun();
    Test.StopTest();
    }
    }