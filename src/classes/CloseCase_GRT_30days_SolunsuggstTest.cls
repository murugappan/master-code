@istest

 Private class CloseCase_GRT_30days_SolunsuggstTest
  {
   /* Static Testmethod void UnitTest()
     {
        test.starttest();
        ScheduleCloseCase_GRT_30days_Solunsuggst b = new ScheduleCloseCase_GRT_30days_Solunsuggst();
        ScheduleCloseCase_GRT_30days_Solunsuggst.scheduleMe();
        test.stoptest();
     }*/ 
      Static Testmethod void myUnitTest()
     {
        test.starttest();
        Datetime days = system.now().addMinutes(-1);

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
        c.Status='Solution Suggested';
        c.Subject = 'test';
        c.Description = 'test';
        c.assetID = aset.ID;
        insert c;

         Solution_Detail__c sd=new Solution_Detail__c();
         sd.Case__c=c.id;
         sd.Status__c = 'In Consideration';
         insert sd;

        c=[select id,LastModifiedDate,Last_activity_update__c from case where id=:c.id and LastModifiedDate >:days and Last_activity_update__c>:days];
   
        CloseCase_GRT_30days_Solunsuggst b = new CloseCase_GRT_30days_Solunsuggst();
        ID batchprocessid = Database.executeBatch(b);
        test.stoptest();
     }
 }