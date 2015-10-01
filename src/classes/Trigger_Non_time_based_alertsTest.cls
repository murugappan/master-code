@isTest
private class Trigger_Non_time_based_alertsTest {

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
    cr.Name = 'ANGEL';
    insert cr;   
    
    
    
    Asset aset = new Asset();
    aset.Name = 'Test Asset 111';
    aset.Core_License__c = cr.ID;
    aset.AccountID = ac.ID;
    aset.Installed_Product_ID__c = '123555';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
    
    
    Case cassoftsol = new Case();        //for angel software solutions
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '2';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset.ID;
    cassoftsol.status='Reopened';
    cassoftsol.X30_mins_mail__c=false; 
    cassoftsol.X45_min_mail__c=false; 
    cassoftsol.X60_min_mail__c=false; 
    insert cassoftsol;
    cassoftsol.status='Needs Attention';
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.X30_mins_mail__c=True;
    cassoftsol.X45_min_mail__c=True; 
    cassoftsol.X60_min_mail__c=True;
    //Update cassoftsol;
    
    
   
    
     }
  }