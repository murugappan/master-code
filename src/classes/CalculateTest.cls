/* Test Class for Trigger on Responsiveness object*/
@istest
Private class CalculateTest{
 Private static Testmethod void  calculate()
 {
   Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
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
    
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;
    
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='2';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
    
    Case cs2=new Case();
    cs2.Status='Solution Suggested';
    cs2.Description='this case has to be resolved';
    cs2.Type='abc';
    cs2.Subject='abc';
    cs2.Case_Severity__c='3';
    cs2.Primary_Group_Name__c='ANGEL - Development';
    cs2.Previous_Owner__c='yyyy';
    cs2.AccountId=ac.id;
    cs2.Account=ac;
    cs2.Contact=ct;
    cs2.AssetID=a.ID;
    cs2.Replication_in_the_Case__c = 'Test';
    insert cs2;
    
    SLA_Information__c Sla = new  SLA_Information__c();
    Sla.CurrencyIsoCode='GBP';
    Sla.Core_License__c=cl.id;
    Sla.Event_Type__c = 'Initial';
    Sla.Severity__c='1';
    Sla.SLA__c=12;
    insert Sla;
    
    
    SLA_Information__c Slb = new  SLA_Information__c();
    Slb.CurrencyIsoCode='GBP';
    Slb.Core_License__c=cl.id;
    Slb.Event_Type__c = 'Followup';
    Slb.Severity__c='1';
    Slb.SLA__c=12;
    insert Slb;
    
    
    Responsiveness__c rr = new Responsiveness__c();
    rr.CurrencyIsoCode='GBP';
    rr.Case__c=cs1.id;
   rr.Start_Time__c=datetime.newInstance(2012, 06,22);
    rr.Grace_Time__c=122;
    rr.SLA_Expiry_Time__c=datetime.now();
    Insert rr;
   Responsiveness__c rr1 = new Responsiveness__c();
    rr1.CurrencyIsoCode='GBP';
    rr1.Case__c=cs1.id;
    rr1.Event_Type__c = 'Initial';
    rr1.Grace_Time__c=122;
    rr1.SLA_Expiry_Time__c=datetime.now();
    Insert rr1;  
 //   update rr1;
   Responsiveness__c rr2 = new Responsiveness__c();
    rr2.CurrencyIsoCode='GBP';
    rr2.Case__c=cs1.id;
    rr2.Start_Time__c=datetime.newInstance(2012,06,23);
    rr2.Grace_Time__c=124;
    rr2.SLA_Expiry_Time__c=datetime.now();
    Insert rr2;   
    rr2.Stop_Time__c=datetime.newInstance(2012,06,29);
    rr2.Event_Type__c = 'Initial';
    update rr2;
    rr2.Stop_Time__c=datetime.newInstance(2012,06,29);
    update rr2;
    rr2.Event_Type__c = 'Follow Up';
    Update rr2;
    Responsiveness__c rr3 = new Responsiveness__c();
    rr3.CurrencyIsoCode='GBP';
    rr3.Case__c=cs2.id;
    rr3.Start_Time__c=datetime.newInstance(2012,06,28);
    rr3.Grace_Time__c=124;
    rr3.SLA_Expiry_Time__c=datetime.now();
    Insert rr3; 
    rr3.Stop_Time__c=datetime.newInstance(2012,06,29); 
    update rr3;
 
 
 }
 }