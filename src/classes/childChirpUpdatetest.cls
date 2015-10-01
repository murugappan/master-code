@istest
private class childChirpUpdatetest{

private static  testmethod void childChirp()
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
 
 CHIRP_Ticket__c ctt = new CHIRP_Ticket__c();
 ctt.CurrencyIsoCode='GBP';
 ctt.Case__c=cs1.id;
 ctt.Component__c='Account Management';
 ctt.Current_Behavior__c='asdsad';
 ctt.Details__c='details about';
 ctt.Expected_Behavior__c='test';
 ctt.Fixed_In_Instance__c='QAX';
  ctt.Subject__c='124455';
 insert ctt;
 CHIRP_Ticket__c ctt1 = new CHIRP_Ticket__c();
 ctt1.CurrencyIsoCode='GBP';
 ctt1.Case__c=cs1.id;
 ctt1.Component__c='Account Management';
 ctt1.Current_Behavior__c='asdsad';
 ctt1.Details__c='details about';
 ctt1.Expected_Behavior__c='test';
 ctt1.Fixed_In_Instance__c='QAX';
 ctt1.Subject__c='12445523';
 insert ctt1;

 CHIRP_Ticket__c cttt = new CHIRP_Ticket__c();
 cttt.CurrencyIsoCode='GBP';
 cttt.Case__c=cs1.id;
 cttt.Component__c='Account Management';
 cttt.Current_Behavior__c='asdsad';
 cttt.Details__c='details about';
 cttt.Expected_Behavior__c='test';
 cttt.Fixed_In_Instance__c='QAX';
 cttt.Subject__c='1244556';
 cttt.Parent_Ticket__c=ctt.id;
 cttt.Parent__c=TRUE;
 cttt.State__c='Deferred';
 cttt.Status__c='Open';
 cttt.Planned_Release_Date__c='12/12/12';
 insert cttt;

 ctt.Type__c='Assigned Tasks';
 ctt.Urgency__c='3';
 update ctt;
 
 
 CHIRP_Ticket__c ctt2 = new CHIRP_Ticket__c();
 ctt2.CurrencyIsoCode='GBP';
 ctt2.Case__c=cs1.id;
 ctt2.Component__c='Account Management';
 ctt2.Current_Behavior__c='asdsad';
 ctt2.Details__c='details about';
 ctt2.Expected_Behavior__c='test';
 ctt2.Fixed_In_Instance__c='QAX';
 ctt2.Parent_Ticket__c=cttt.id;
 ctt2.Subject__c='12445563';
 insert ctt2;
 
 cttt.Parent_Ticket__c=ctt1.id;
 cttt.State__c='Duplicate';
 cttt.Status__c='Closed';
 cttt.Planned_Release_Date__c='12/11/12';
 update cttt;
 
   }
 }