@istest
private class BBW_CasePrimaryGroupTest
{
static testmethod void BBW_CasePrimaryGroupTest()
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
cl.Name='Angel';
insert cl;
/*
Asset a=new Asset();
a.Name='abc';
a.Core_License__c=cl.id;
a.AccountId=ac.id;
a.Contact=ct;
a.Account=ac;
insert a;
*/
Module__c m=new  Module__c(); 
m.Name='abc'; 
m.Core_Licence__c=cl.id; 
insert m;

Functional_Area__c fa=new Functional_Area__c();
fa.Name='abc';
fa.Module__c=m.id;
insert fa;

Category__c c=new Category__c();
c.Name='abc';
c.Functional_Area__c=fa.id;
insert c;

Template__c t=new Template__c();
t.Name='abc';
insert t;

User_Lookup__c u=new User_Lookup__c();
u.User__c=UserInfo.getUserId() ;
insert u; 

Case cs=new Case();
cs.Status='Assigned' ;
cs.Description='this case has to be resolved';
//cs.Product_Group__c='abc';
//cs.Asset='FIN AID IMPL PS 30K+';
cs.Type='abc';cs.Subject='abc';
cs.Case_Severity__c='sev 1';
cs.AccountId=ac.id;
cs.Account=ac;
cs.Contact=ct;
//cs.AssetID=a.ID;
cs.Functional_Area__c=fa.id;
cs.Module__c=m.id;
cs.Category__c=c.id;
//cs.Owner.id=UserInfo.getUserId();
insert cs;


system.currentpagereference().getParameters().put('id',cs.id);
ApexPages.StandardController testpg = new ApexPages.StandardController(cs);
BBW_CasePrimaryGroup controller = new BBW_CasePrimaryGroup(testpg);        
controller.ChangePrimaryGroup();
controller.getQueueName();
controller.GroupName='i am trying to excute to catch part for this i have to put some invalid data so that it can excute the catch part Thanku!';      
controller.ChangePrimaryGroup();
}
}