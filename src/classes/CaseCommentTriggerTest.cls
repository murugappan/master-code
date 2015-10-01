@isTest
public class CaseCommentTriggerTest {


static testMethod void myUnitTest(){

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

Case cs=new Case();
cs.Status='New' ;
cs.Description='this case has to be resolved';
cs.Type='abc';
cs.Subject='abc';
cs.Case_Severity__c='sev 1';
cs.Primary_Group_Name__c='Transact';
cs.AccountId=ac.id;
cs.Account=ac;
cs.Contact=ct;
cs.Functional_Area__c=fa.id;
cs.Module__c=m.id;
cs.Category__c=c.id;
insert cs;

caseComment cc = new caseComment();
cc.ParentId = cs.Id;
insert cc;


}

}