@istest
private class SupportIncidentAssignControllertest{
static testmethod void SupportIncidentAssignController() {
profile pf =[select id from profile where name ='SRV - Support Tech' limit 1];
User testuser=[select id from user where profileid =:pf.id and isactive = true limit 1];

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

learnJIRA__c cs=new LearnJIRA__c();
cs.Status__c='Assigned' ;
cs.Summary__c = 'test123';
cs.Functional_Area__c=fa.id;
cs.Module__c=m.id;
cs.Category__c=c.id;
insert cs;

learnJIRANote__c siNote = new learnJIRANote__c();
siNote.Support_Incident__c = cs.Id;
siNote.Title__c = 'Support Incident Hand Off';
insert siNote;

Group gg = new Group(Name='Test group');
insert gg;


test.starttest();
learnJIRA__c cd =new learnJIRA__c();
system.currentpagereference().getParameters().put('id',cs.id);
ApexPages.StandardController testa = new ApexPages.StandardController(cs);
SupportIncidentAssignController controller = new SupportIncidentAssignController(testa);    



controller.SaveOwner();
controller.getQueueList();
controller.getQueueList1();
controller.loadUsers();
controller.getUserList();
controller.loadSupportIncident();

//controller.getprg();
//controller.setprg('abc');
//controller.USValue();
//controller.getRecordName();
//controller.setprg('ALL');



Test.StopTest();

}
}