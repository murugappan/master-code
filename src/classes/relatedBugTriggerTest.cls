/*  This is the test class on Related Bug Objects */
@istest
private class relatedBugTriggerTest {

    static testMethod void myUnitTest() {
    
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
    
    Case c =[select id,CaseNumber from Case where id =: cs1.id];
    
    learnJIRA__c lj = new learnJIRA__c();
    lj.Name = 'Test';
    lj.Origin_Case_Number__c = c.CaseNumber;
    lj.OriginCaseID__c = c.Id;
    lj.Summary__c = 'Test Summary';
    lj.Status__c = 'New';
    insert  lj;
    
    Related_Bug__c rb1 = new Related_Bug__c();
    rb1.Name = 'Test Version1';
    rb1.Support_Incident__c = lj.Id;
    insert rb1;
      
    
    Related_Bug__c rb = new Related_Bug__c();
    rb.Name = 'Test Version';
    rb.Support_Incident__c = lj.Id;
    insert rb;
    
    rb.Timeframe__c='20 Days';
    rb.Name = 'Test Version2';
    update rb;
      
    delete rb;
    
   
    
      }
  }