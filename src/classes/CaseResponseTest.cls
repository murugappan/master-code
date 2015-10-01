@isTest
Private class CaseResponseTest{       
   
   static testMethod void myUnitTest(){
   
   Profile p = [select id from profile where name='SRV - System Administrator'];
   
   
   User user = TestMethodUtility.createUser(p);
   
   insert user; 
   System.Runas(user)
   {
    
     
    Account ac=new Account();
    ac.Name='Heritage university';
    ac.BillingCity='abc';
    ac.BillingCountry='India';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    insert ac;
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    Core_License__c cl=new Core_License__c();
    cl.Name='ANGEL';
    insert cl;
    SLA_Information__c ssl = new SLA_Information__c(CurrencyIsoCode='GBP',Core_License__c='ANGEL', Event_Type__c = 'Initial',
    Severity__c='3',SLA__c=1);
    insert ssl;  

    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    a.Support_Level__c = 'ANGEL Premium Support' ;
    insert a;
    BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
   Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='3';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    cs1.Invoke_Premium_Support__c = true;
    cs1.BusinessHoursID=b1.id;
    insert cs1;
    update cs1;
         
   }
}
static testMethod void myUnitTest1(){
   
   Profile p = [select id from profile where name='SRV - System Administrator'];
   
   
   User user = TestMethodUtility.createUser(p);
   
   insert user; 
   System.Runas(user)
   {
    
     
    Account ac=new Account();
    ac.Name='Heritage university';
    ac.BillingCity='abc';
    ac.BillingCountry='India';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    insert ac;
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    Core_License__c cl=new Core_License__c();
    cl.Name='Learn';
    insert cl;
    SLA_Information__c ssl = new SLA_Information__c(CurrencyIsoCode='GBP',Core_License__c='Learn', Event_Type__c = 'Initial',
    Severity__c='3',SLA__c=1);
    insert ssl;  

    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    a.Support_Level__c = 'ANGEL Premium Support' ;
    insert a;
    BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='3';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    cs1.Invoke_Premium_Support__c = true;
    cs1.BusinessHoursID=b1.id;
    insert cs1;
    update cs1;
         
   }
}
static testMethod void myUnitTest3(){
   
   Profile p = [select id from profile where name='SRV - System Administrator'];
   
   
   User user = TestMethodUtility.createUser(p);
   
   insert user; 
   System.Runas(user)
   {
    
     
    Account ac=new Account();
    ac.Name='Heritage university';
    ac.BillingCity='abc';
    ac.BillingCountry='India';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    insert ac;
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    Core_License__c cl=new Core_License__c();
    cl.Name='CE';
    insert cl;
    SLA_Information__c ssl = new SLA_Information__c(CurrencyIsoCode='GBP',Core_License__c='CE', Event_Type__c = 'Initial',
    Severity__c='3',SLA__c=1);
    insert ssl;  

    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    a.Support_Level__c = 'ANGEL Premium Support' ;
    insert a;
    BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='3';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    cs1.Invoke_Premium_Support__c = true;
    cs1.BusinessHoursID=b1.id;
    insert cs1;
    update cs1;
         
   }
}
static testMethod void myUnitTest4(){
   
   Profile p = [select id from profile where name='SRV - System Administrator'];
   
   
   User user = TestMethodUtility.createUser(p);
   
   insert user; 
   System.Runas(user)
   {
    
     
    Account ac=new Account();
    ac.Name='Heritage university';
    ac.BillingCity='abc';
    ac.BillingCountry='India';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    insert ac;
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    Core_License__c cl=new Core_License__c();
    cl.Name='Xythos';
    insert cl;
    SLA_Information__c ssl = new SLA_Information__c(CurrencyIsoCode='GBP',Core_License__c='Xythos', Event_Type__c = 'Initial',
    Severity__c='3',SLA__c=1);
    insert ssl;  

    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    a.Support_Level__c = 'ANGEL Premium Support' ;
    insert a;
    BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='3';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    cs1.Invoke_Premium_Support__c = true;
    cs1.BusinessHoursID=b1.id;
    insert cs1;
    update cs1;
         
   }
}
static testMethod void myUnitTest5(){
   
   Profile p = [select id from profile where name='SRV - System Administrator'];
   
   
   User user = TestMethodUtility.createUser(p);
   
   insert user; 
   System.Runas(user)
   {
    
     
    Account ac=new Account();
    ac.Name='Heritage university';
    ac.BillingCity='abc';
    ac.BillingCountry='India';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    insert ac;
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    Core_License__c cl=new Core_License__c();
    cl.Name='Transact';
    insert cl;
    SLA_Information__c ssl = new SLA_Information__c(CurrencyIsoCode='GBP',Core_License__c='Transact', Event_Type__c = 'Initial',
    Severity__c='3',SLA__c=1);
    insert ssl;  

    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    a.Support_Level__c = 'ANGEL Premium Support' ;
    insert a;
    BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='3';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    cs1.Invoke_Premium_Support__c = true;
    cs1.BusinessHoursID=b1.id;
    insert cs1;
    update cs1;
         
   }
}






}