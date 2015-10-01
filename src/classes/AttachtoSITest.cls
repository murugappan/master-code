//Test class for  Trigger on Attachment Object( Case_Attachment__c) including AttachtoSI and   SI_attachment_Insert_Update
// trigger
@isTest
private class AttachtoSITest {

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
    
    learnJIRA__c lj = new learnJIRA__c();
    lj.Name = 'Test';
    lj.Origin_Case_Number__c = cs1.CaseNumber;
    lj.OriginCaseID__c = cs1.Id;
    lj.Summary__c = 'Test Summary';
    lj.Status__c = 'New';
    insert lj;
    
    Case_Attachment__c ca = new Case_Attachment__c();
    ca.CurrencyIsoCode='GBP';
    ca.Support_Incident__c=lj.id;
    ca.Relate_to_SI__c=True;
    ca.Related_To__c=cs1.id;
    insert ca;
    ca.Relate_to_SI__c=True;
    ca.Related_To__c=cs1.id;
    update ca;
    ca.Relate_to_SI__c=False;
    update ca;
    ca.Relate_to_SI__c=True;
    update ca;
    
        }
   }