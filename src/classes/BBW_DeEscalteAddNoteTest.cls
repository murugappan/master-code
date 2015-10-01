@istest
private class BBW_DeEscalteAddNoteTest
{
static testmethod void BBW_DeEscalteAddNoteTest()
{
/*Account ac=new Account();
ac.Name='bucknell university';
ac.BillingCity='abc';
ac.BillingCountry='India';
ac.BillingPostalCode='abc';
ac.BillingState='abc';
ac.BillingStreet='abc';
insert ac;
Contact ct= new Contact ();
ct.AccountId=ac.id;
ct.Account=ac;ct.LastName='abc';
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
insert u;*/
Account b = new Account();
    b.Name = 'Test Account1';
    b.BillingStreet = 'Test Street1';         //for Angel Managed hosting
    b.BillingCity = 'Test City1';
    b.BillingState = 'Test State1';
    b.BillingCountry = 'USA'; 
    b.BillingPostalCode = 'Test Code1';
    b.Type = 'Partner';
    //b.Complex_Hosting__c = false;
    //b.Managed_Hosting__c = false;
    insert b;
    
 Contact c1 = new Contact();
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = b.ID;
    insert c1;
    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'Angel';
    insert cr;
    
    
    Asset asetsev1 = new Asset();
    asetsev1.Name = 'Test Asset 10';
    asetsev1.Core_License__c = cr.ID;
    asetsev1.AccountId = b.Id;
    asetsev1.Managed_Hosting__c = 'ANGEL - Managed Hosting';
    insert asetsev1;
    
    
 Case cas1 = new Case();
    cas1.AccountID = b.ID;
    cas1.ContactID = c1.ID;
    cas1.AssetId = asetsev1.ID;          //for angel managed hosting
    cas1.Case_Severity__c = '1';
  //  cas1.OwnerId='005Q0000000dz8jIAA';    
    insert cas1;
    
ApexPages.currentPage().getParameters().put('id',cas1.id);
System.debug('case id---------------->>>>>>'+cas1.id);
System.debug('case primary group---------------->>>>>>'+cas1.Primary_Group_Name__c);
ApexPages.StandardController testden = new ApexPages.StandardController(cas1);
BBW_DeEscalteAddNote controller = new BBW_DeEscalteAddNote(testden); 
controller.UserComment='abc';
controller.SubjectValue='def';
controller.DeEscalateInfo();



cas1.Escalated_Tier_3__c=False;
cas1.Escalated_Tier_2__c=true;
//cas1.Previous_Owner__c='005Q0000000dz8jIAA';
//cas1.OwnerId='005Q0000000eQwsIAE';
update cas1;
controller.DeEscalateInfo();

controller.UserComment=null;
controller.DeEscalateInfo();

controller.SubjectValue=null;
controller.UserComment='abc';
controller.DeEscalateInfo();



}
 }