@istest
private class BBW_CaseListTest
{
static testmethod void BBW_CaseListTest()
{
list<Account> acs=new list<Account>();
for(integer i=0;i<10;i++)
{
acs.add(new Account(
Name='bucknell university'+i,
BillingCity='abc'+i,
BillingCountry='USA',
BillingPostalCode='abc'+i,
BillingState='abc'+i,
BillingStreet='abc'+i));
}
insert acs;

list<Contact> ct= new list<Contact>();
for(integer i=0;i<10;i++)
{
ct.add(new Contact(
AccountId=acs[i].id,
Account=acs[i],
LastName='abc'+i));
}
insert ct;

list<Core_License__c> cl=new list<Core_License__c>();
for(integer i=0;i<10;i++)
{
cl.add(new Core_License__c(
Name='Angel'+i));
}
insert cl;

/*
List<Asset> a=new List<Asset>();
for(integer i=0;i<10;i++)
{
a.add(new Asset(Name='abc',
Core_License__c=cl[i].id,
AccountId=acs[i].id,
Contact=ct[i],
Account=acs[i]));
}
insert a;
*/
list<Module__c> m=new  list<Module__c>(); 
for(integer i=0;i<10;i++)
{
m.add(new Module__c(
Name='abc'+i, 
Core_Licence__c=cl[i].id ));
}
insert m;

list<Functional_Area__c> fa=new list<Functional_Area__c>();
for(integer i=0;i<10;i++)
{
fa.add(new Functional_Area__c(
Name='abc',
Module__c=m[i].id));
}
insert fa;

list<Category__c> c=new list<Category__c>();
for(integer i=0;i<10;i++)
{
c.add(new Category__c(
Name='abc'+i,
Functional_Area__c=fa[i].id));
}
insert c;

list<Template__c> t=new list<Template__c>();
for(integer i=0;i<10;i++)
{
t.add(new Template__c(
Name='abc'));
}
insert t;

User_Lookup__c u=new User_Lookup__c();
u.User__c=UserInfo.getUserId() ;
insert u; 

List<Case> cs=new List<Case>();
for(integer i=0;i<10;i++)
{
cs.add(new Case(
Status='Assigned',
Description='this case has to be resolved',
//cs.Product_Group__c='abc';
//cs.Asset='FIN AID IMPL PS 30K+';
Type='abc',
Subject='abc',
Case_Severity__c='sev 1',
AccountId=acs[i].id,
Account=acs[i],
Contact=ct[i],
//AssetID=a[i].ID,
Functional_Area__c=fa[i].id,
Module__c=m[i].id,
Category__c=c[i].id
//cs.Owner.id=UserInfo.getUserId();
));
}
insert cs;


/*system.currentpagereference().getParameters().put('id',cs.id);
ApexPages.StandardController testpg = new ApexPages.StandardController(cs);
BBW_CasePrimaryGroup controller = new BBW_CasePrimaryGroup(testpg);        
controller.ChangePrimaryGroup();
controller.getQueueName();*/
ApexPages.StandardSetController testpg = new ApexPages.StandardSetController(cs);
//testpg.setSelected(cs);


BBW_CaseList clo=new BBW_CaseList(testpg);
ApexPages.CurrentPage().getParameters().put('firstParam','def');
//clo.sortcon='def';
Test.startTest();
        clo.updatelist();
        
        ApexPages.CurrentPage().getParameters().put('firstParam','acc');
        clo.updatelist();
         clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','sev');
        clo.updatelist();
         clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','acn');
        clo.updatelist();
         clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','crdt');
        clo.updatelist();
         clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','psftcid');
        clo.updatelist();
         clo.updatelist();
         ApexPages.CurrentPage().getParameters().put('firstParam','lmdt');
        clo.updatelist();
       clo.updatelist();





ApexPages.CurrentPage().getParameters().put('firstParam','sta');
        clo.updatelist();
         clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','sub');
        clo.updatelist();
  clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','cas');
        clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','hello');
        clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','age');
clo.updatelist();
clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','sla');
clo.updatelist();
clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','tsla');
clo.updatelist();
clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','evt');
clo.updatelist();
clo.updatelist();
ApexPages.CurrentPage().getParameters().put('firstParam','cla');
clo.updatelist();
clo.updatelist();
     Test.stopTest();





}
}