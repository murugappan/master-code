// This is test class for Class: BBW_CaseListGrabCase

@istest
private class BBW_CaseListGrabCaseTest
{
@testSetup static void setupmethod()
{
   Profile p =[select id,Name from Profile where Name ='System Administrator'];
    //This user is used to assign Ownerid

    User u1=TestMethodUtility.CreateUser(p);
    insert u1;

   User uu =[select Name from User where id= :u1.id];

   //This is Current user

    User u2=TestMethodUtility.CreateUser(p);
    u2.Primary_Group__c=uu.Name;
    insert u2;

    System.Runas(u2)
     {
    Account ac=TestMethodUtility.createAccount();
    insert ac;

   Contact ct= TestMethodUtility.createContact(ac);
   insert ct;

   Core_License__c cl=TestMethodUtility.createCoreLicense();
   cl.Name='Angel';
   insert cl;


    Module__c m=TestMethodUtility.createModule(cl);
    insert m;

   Functional_Area__c fa=TestMethodUtility.createFunctionalArea(m);
   insert fa;

   Category__c c=TestMethodUtility.createCategory(fa);
   insert c;

   Template__c t=TestMethodUtility.CreateTemplate();
   insert t;

   User_Lookup__c u=TestMethodUtility.CreateLookupUser(u2);
   insert u; 

   Asset ast = TestMethodUtility.createAsset(ac,cl);
   insert ast;

//This case has ownerid is different from current user
  list<case> caselist=new list<case>(); 
  Case cs=TestMethodUtility.createCase1(ac,ast);
  cs.Status='New' ;
  cs.Description='this case has to be resolved';
  cs.Type='abc';cs.Subject='abc';
  cs.Case_Severity__c='sev 1';
  cs.AccountId=ac.id;
  cs.Account=ac;
  cs.Contact=ct;
  cs.Functional_Area__c=fa.id;
  cs.Module__c=m.id;
  cs.Category__c=c.id;
  cs.Ownerid=u1.id;
  cs.Primary_Group_Name__c =u2.Primary_Group__c ;
 caselist.add(cs);

  Case cs2=TestMethodUtility.createCase1(ac,ast);
  cs2.Status='New' ;
  cs2.Description='this case has to be resolved';
  cs2.Type='abc';cs.Subject='abc';
  cs2.Case_Severity__c='sev 1';
  cs2.AccountId=ac.id;
  cs2.Account=ac;
  cs2.Contact=ct;
  cs2.Functional_Area__c=fa.id;
  cs2.Module__c=m.id;
  cs2.Category__c=c.id;
 caselist.add(cs2);

//This user has ownerid is differetn from current user

  Case cs3=TestMethodUtility.createCase1(ac,ast);
  cs3.Status='New' ;
  cs3.Description='this case has to be resolved';
  cs3.Type='abc';
  cs3.Subject='abc';
  cs3.Case_Severity__c='sev 1';
  cs3.AccountId=ac.id;
  cs3.Account=ac;
  cs3.Contact=ct;
  cs3.Functional_Area__c=fa.id;
  cs3.Module__c=m.id;
  cs3.Category__c=c.id;
  cs3.Ownerid=u1.id;
  cs3.Primary_Group_Name__c =u2.Primary_Group__c ;
caselist.add(cs3);
insert caselist;

list<Responsiveness__c> response_list=new list<Responsiveness__c>();
  Responsiveness__c res =TestMethodUtility.CreateResponsive(cs);
  res.Start_Time__c=System.today()-3;
  res.Stop_Time__c=System.today()+ 3;
  response_list.add(res);

  Responsiveness__c res1 =TestMethodUtility.CreateResponsive(cs3);
  res1.Start_Time__c=System.today()-3;
  res1.Stop_Time__c=System.today()+ 3;
  response_list.add(res1);

  Responsiveness__c res2 =TestMethodUtility.CreateResponsive(cs3);
  res2.Start_Time__c=System.today()-3;
  res2.Stop_Time__c=System.today()+ 3;
  response_list.add(res2);
  insert response_list;
}

}

 static testmethod void BBW_CaseListGrabCaseTest()
  {

  Profile p =[select id,Name from Profile where Name ='System Administrator'];
    //This user is used to assign Ownerid

    User u1=[select id from user where profileid=:p.id and isactive=true  order by createddate desc limit 1];
system.runas(u1)
{
  BBW_CaseListGrabCase clo=new BBW_CaseListGrabCase();
ApexPages.CurrentPage().getParameters().put('firstParam','def');

clo.buildCaseSelectList();
clo.addSelectedCases();
        clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','acc');
        clo.OwnerName= 'Owner Name &darr;';

        clo.updatelist();
        clo.OwnerName= 'Owner Name &uarr;';
        clo.updatelist();
Test.startTest();
        ApexPages.CurrentPage().getParameters().put('firstParam','sev');
        clo.updatelist();
        clo.updatelist();
        clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','acn');
        clo.updatelist();
        clo.updatelist();
        clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','crdt');
        clo.updatelist();
        clo.updatelist();
        clo.updatelist();

        ApexPages.CurrentPage().getParameters().put('firstParam','sub');
        clo.updatelist();
        clo.updatelist();
        clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','psftcid');
        clo.updatelist();
        clo.updatelist();
        clo.updatelist();
        ApexPages.CurrentPage().getParameters().put('firstParam','lmdt');
        clo.updatelist();
        clo.updatelist();
        clo.updatelist();


   
       ApexPages.CurrentPage().getParameters().put('firstParam','cas');
        clo.CaseNumber='Case # &darr;';
        clo.updatelist();
        clo.CaseNumber='Case # &uarr;';
        clo.updatelist();
        
        
        ApexPages.CurrentPage().getParameters().put('firstParam','psftcid');
        clo.PsftCaseId='psftcid &darr;';
        clo.updatelist();
        clo.PsftCaseId='psftcid &uarr;';
        clo.updatelist();

        
        
        
       ApexPages.CurrentPage().getParameters().put('firstParam','hello');
       clo.updatelist();

       ApexPages.CurrentPage().getParameters().put('firstParam','sta');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','sub');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','cas');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','hello');
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','age');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','sla');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','tsla');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','evt');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();
       ApexPages.CurrentPage().getParameters().put('firstParam','cla');
       clo.updatelist();
       clo.updatelist();
       clo.updatelist();

     Test.stopTest();
     }
}
}