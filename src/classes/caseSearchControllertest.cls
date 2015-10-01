@isTest(seealldata=true)
private without sharing class caseSearchControllertest {

  static testmethod void caseSearchControllertest(){
   
    PageReference page = new PageReference('/apex/btbb_caseSearch');
    Test.setCurrentPage(page);
    
     User user =[Select id,contactid from user where Profile.Name='SRV - BTBB User' and contactid!=Null and Isactive=true limit 1];
    
      Account acc = TestMethodUtility.createAccount();
       acc.ownerid=userinfo.getuserid();
       insert acc;
       
       Contact c =[Select id from Contact where id=: user.contactid limit 1];
       
       Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
       cr.Role__c = 'COLLABORATE - System Admin';
       cr.Contact__c=c.id;
       insert cr;
       
       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate';           
       insert core;
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       case cs = TestMethodUtility.createCase(c,core,acc,m);
       insert cs;
       
        
        
       string product1;
        
    caseSearchController csc = new caseSearchController();
   // system.runas(user)
    {
      csc = new caseSearchController();
        Test.setCurrentPage(page);
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.product='Collaborate';
        product1=authcookie.product;
        authcookie.createcookie();
        
        csc.Redirect();
        csc.getRecentCases();
        csc.getMyName();
        csc.getMyFirstName();
        csc.getMyLastName();
        csc.resetfilter();
        Boolean b = csc.isreadonly;
      }
    } 

    static testmethod void UnitTestAnalyticsPositiveScenarios(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runAs(sysuser){
         PageReference page = new PageReference('/apex/btbb_caseSearch');
         Test.setCurrentPage(page);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.name='abc';
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Analytics';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Account__c=ac.id;
        crr.Role__c= 'Analytics - Admin';
        
        insert crr;

          Asset a=new Asset();
          a.Name='abc';
          a.Core_License__c=cr.id;
          a.AccountId=ac.id;
          a.Contact=cont;
          a.Account=ac;
          insert a;

          Module__c m=new  Module__c(); 
          m.Name='abc'; 
          m.Core_Licence__c=cr.id; 
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

            Case cs=new Case();
            cs.Status='new' ;
            cs.Description='this case has to be resolved';
            //cs.Product_Group__c='abc';
            //cs.Asset='FIN AID IMPL PS 30K+';
            cs.Type='abc';cs.Subject='abc';
            cs.Case_Severity__c='sev 1';
            cs.AccountId=ac.id;
            cs.Account=ac;
            cs.Contact=cont;
            cs.AssetID=a.ID;
            cs.Functional_Area__c=fa.id;
            cs.Module__c=m.id;
            cs.Category__c=c.id;
            //cs.Owner.id=UserInfo.getUserId();
            insert cs;
            system.debug('contactrole'+crr.Role__c+'accname'+ac.name);
        system.runAs(u){

       caseSearchController csc = new caseSearchController();

          }

      }

   } 

   static testmethod void UnitTestxpLorPositiveScenarios(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runAs(sysuser)
      {
         
        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.name='abc';
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];

        User u = TestMethodUtility.createUser(p1);
        u.contactId = cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'xpLor';
        insert cr;

        Core_License__c cr1 = TestMethodUtility.createCoreLicense();
        cr1.Name = 'Analytics';
        insert cr1;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Account__c=ac.id;
        crr.Role__c= 'XPLOR - Admin';
        
        insert crr;

        Contact_Role__c crr1 = TestMethodUtility.createContactRole(ac);
        crr1.Expire_Role__c=False;
        crr1.Contact__c=u.contactId;
        crr1.Account__c=ac.id;
        crr1.Role__c= 'ANALYTICS - Admin';
        
        insert crr1;

          Asset a=new Asset();
          a.Name='abc';
          a.Core_License__c=cr.id;
          a.AccountId=ac.id;
          a.Contact=cont;
          insert a;

          Asset a1=new Asset();
          a1.Name='abc';
          a1.Core_License__c=cr1.id;
          a1.AccountId=ac.id;
          a1.Contact=cont;
          insert a1;

          Module__c m=new  Module__c(); 
          m.Name='abc'; 
          m.Core_Licence__c=cr.id; 
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

          id xprecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('xpLor').getRecordTypeId();
          id Anrecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('Analytics').getRecordTypeId();

            Case cs=new Case();
            cs.AccountId=ac.id;
            cs.Contact=cont;
            cs.AssetID=a.ID;
            cs.Functional_Area__c=fa.id;
            cs.Module__c=m.id;
            cs.Category__c=c.id;
            cs.Status='new' ;
            cs.Description='this case has to be resolved';
            cs.Type='abc';
            cs.Subject='abc';
            cs.Case_Severity__c='sev 2';
            cs.RecordTypeId = xprecordtypeid;
            cs.Core_License__c = a.Core_License__c;
            insert cs;

            Case cs1=new Case();
            cs1.AccountId=ac.id;
            cs1.Contact=cont;
            cs1.AssetID=a1.ID;
            cs1.Status='new' ;
            cs1.Description='this case has to be resolved';
            cs1.Type='abc';
            cs1.Subject='abc';
            cs1.Case_Severity__c='sev 2';
            cs1.RecordTypeId = Anrecordtypeid;
            cs1.Core_License__c = a1.Core_License__c;
            insert cs1;
            system.debug('contactrole'+crr.Role__c+'accname'+ac.name);
           
          system.runAs(u)
          {
            PageReference page = new PageReference('/apex/btbb_caseSearch');
            Test.setCurrentPage(page);
            caseSearchController csc = new caseSearchController();
            csc.Redirect();
          }
       }
     } 
   }