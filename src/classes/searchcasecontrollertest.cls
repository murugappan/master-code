@isTest
private with sharing class searchcasecontrollertest {
    
    
    static testmethod void searchcasecontrollertest(){
      
       PageReference page = new PageReference('/apex/btbb_searchcase');
       Test.setCurrentPage(page);
       
       // User
        User u1 =[select id,Contactid from user where contactid !=Null and Profile.Name='SRV - BTBB User' and Isactive=true limit 1];
       
       Account acc = TestMethodUtility.createAccount();
       
       insert acc;
       
       Contact c = TestMethodUtility.createContact(acc);
       c.PS_Person_Id__c='98984573';
       insert c;
       
        // List of Contact role
       List<Contact_Role__c> ConRoleLis = New List<Contact_Role__c>();
       Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
       cr.Role__c = 'COLLABORATE - System Admin';
       cr.Expire_Role__c = false;
       cr.Contact__c=u1.Contactid;
       
      
       
       Contact_Role__c cr1 = TestMethodUtility.createContactRole(acc);
       cr1.Role__c = 'COLLABORATE - System Admin';
       cr1.Expire_Role__c = false;
       cr1.Contact__c=u1.Contactid;
       
     
       
        Contact_Role__c cr2 = TestMethodUtility.createContactRole(acc);
        cr2.Role__c = 'COLLABORATE - System Admin';
        cr2.Expire_Role__c = false;
        cr2.Contact__c=u1.Contactid;
       
      
       
       ConRoleLis.add(cr);
       ConRoleLis.add(cr1);
       ConRoleLis.add(cr2);
       Insert ConRoleLis;
       
       
       
       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate';           
       insert core;
       
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       
       EndUser__c e = new EndUser__c(Name = 'test',Email__c= 'test.ajith@gmail.com');
       insert e;
       
       case cs = TestMethodUtility.createCase(c,core,acc,m);
       cs.ContactId = null;
       cs.End_User__c = e.id;
       insert cs;
       
      // Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];
       
      // User u1 = TestMethodUtility.createUser(pf1);
     //  u1.ContactId = c.id;
       //u1.UserRole
       
      
      
     
       string product1;
      
       searchcasecontroller csc1 = new searchcasecontroller();  
       
       
       system.runas(u1)
      { 
      
       
      
        
        searchcasecontroller csc = new searchcasecontroller();
        Test.setCurrentPage(page);
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.product='XYZ';
        product1=authcookie.product;
        authcookie.createcookie();
        
        //csc.getRecentCases();
        //csc.getMyName();
        //csc.getMyFirstName();
        //csc.getMyLastName();
        //csc.resetfilter();
        //Boolean b = csc.isMLAAdmin;
       // csc.Redirect();
        
        
     }
      
      //  csc.Redirect();
      
    } 
    
     static testmethod void searchcasecontrollertest1(){ 
     
     
     searchcasecontroller csc = new searchcasecontroller();
     //csc.Redirect();
     
       Account acc = TestMethodUtility.createAccount();
       acc.ownerid=userinfo.getuserid();
       
       insert acc;
       
          
       Account acc1 = TestMethodUtility.createAccount();
      // acc.ownerid=userinfo.getuserid();
       insert acc1;
       
       Contact c = TestMethodUtility.createContact(acc);
       c.PS_Person_Id__c='98984573';
       insert c;
       
       Contact_Role__c cr1 = TestMethodUtility.createContactRole(acc);
       //cr.Role__c = 'COLLABORATE - System Admin';
       cr1.Contact__c=c.id;
       cr1.Expire_Role__c =false;
       insert cr1;
       
       Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
       //cr.Role__c = 'COLLABORATE - System Admin';
       cr.Contact__c=c.id;
       cr.Expire_Role__c =false;
       insert cr;
       
       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate';           
       insert core;
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       
       EndUser__c e = new EndUser__c(Name = 'test',Email__c= 'test.ajith@gmail.com');
       insert e;
       
       case cs = TestMethodUtility.createCase(c,core,acc,m);
       cs.ContactId = null;
       cs.End_User__c = e.id;
       insert cs;
       
       
       Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];
       
       User u1 =[select id from user where contactid !=Null and Profile.Name='SRV - BTBB User' and Isactive=true limit 1];
       
      
       Contact cc = New Contact();
       
       case cs1 = TestMethodUtility.createCase(cc,core,acc,m);
       cs1.ContactId = null;
       cs1.End_User__c = e.id;
       insert cs1;

       searchcasecontroller csc11 = new searchcasecontroller();
       
       system.runas(u1)
       {
       
       
     
       searchcasecontroller csc1 = new searchcasecontroller();
     
     
     
      } 
     
     }

}