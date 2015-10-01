@istest
private class SupportIncidentHandOffControllertest
{
static testmethod void SupportIncidentHandOffController()
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

Asset a=new Asset();
a.Name='abc';
a.Core_License__c=cl.id;
a.AccountId=ac.id;
a.Contact=ct;
a.Account=ac;
insert a;

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

learnJIRA__c cs=new learnJIRA__c();
cs.Status__c='Assigned' ;
cs.Summary__c = 'test123';

cs.Functional_Area__c=fa.id;
cs.Module__c=m.id;
cs.Category__c=c.id;
//cs.Owner.id=UserInfo.getUserId();
insert cs;




learnJIRANote__c siNote = new learnJIRANote__c();
siNote.Support_Incident__c = cs.Id;
siNote.Title__c = 'Support Incident Hand Off';


Group gg = new Group(Name='Test group');
insert gg;




learnJIRA__c cs1=new learnJIRA__c();
system.currentpagereference().getParameters().put('id',cs1.id);
ApexPages.StandardController testhf = new ApexPages.StandardController(cs);
SupportIncidentHandOffController controller = new SupportIncidentHandOffController(testhf);        
controller.SaveOwner();
//controller.getRecName();
//controller.setRecName('abc');
//controller.Values();
controller.getQueueList();
controller.getQueueList1();

controller.SaveOwner();

}
}