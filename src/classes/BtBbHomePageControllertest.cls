/*
This is test class for BtBbHomePageController
Date:20.05.2012
*/
@isTest(seeAllData=true)
private class BtBbHomePageControllertest {

    static testMethod void myUnitTest() {
       
        
        
        Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];                  
        user u2 =[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];         
        contact c=[select PS_Person_Id__c from contact where id=:u2.contactId ];
        c.PS_Person_Id__c='abc173';
        update c;
        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
                
        Contact ct= TestMethodUtility.createContact(ac);
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
        
        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        insert cr;  
        
                
        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=c.Id;
        crr.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr;
        
        Contact_Role__c crr2 =TestMethodUtility.createContactRole(ac);
        crr2.CurrencyIsoCode='GBP';
        crr2.Expire_Role__c=False;
        crr2.Contact__c=u2.contactId;
        crr2.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr2;
        
    
       Asset a=TestMethodUtility.createAsset(ac,cr);
       a.Name='abc';
       a.Contact=ct;
       insert a;
    
      Case cs1=TestMethodUtility.createCase1(ac,a);
      cs1.Status='Solution Suggested';
      cs1.Description='this case has to be resolved';
      cs1.Type='abc';
      cs1.Subject='abc';
      cs1.Case_Severity__c='2';
      cs1.Primary_Group_Name__c='ANGEL - Development';
      cs1.Previous_Owner__c='yyyy';
      cs1.AccountId=ac.id;
      cs1.Contact=ct;
      cs1.Replication_in_the_Case__c = 'Test';
      insert cs1;
        
       
     
         System.runas(u2) {             
                           
        BtBbHomePageController home = new BtBbHomePageController();
        pageReference pageRedirect = new PageReference('http://en.wikipedia.org/wiki/Salesforce.com');
        pageRedirect.getParameters().put('returnURL',pageRedirect .getUrl());
        pageRedirect.setRedirect(true);
        home.Redirect();
        home.xythosonly = true;
        home.Redirect();
           
           system.debug('Contact role--'+ [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u2.ContactID AND Expire_Role__c = false]);
            Test.StartTest();
            home = new BtBbHomePageController();          
            home.runFromTest = true;
            home.getRecentCases();
            home.getArticleCategories();
            Boolean b = home.isMHDisplay;
            Boolean b1 = home.isMLAAdmin;
            Boolean b2 = home.xythosonly;        
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5();  
            home.selectedProduct='CE/Vista'; 
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5(); 
            home.selectedProduct='Xythos'; 
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5();   
            Test.StopTest();
        }
    
    }
    
 static testmethod void BtBbHomePageControllertest1(){
        
               
       User u3=[select id,contactid from user where contactid !=Null and isactive=True limit 1];
       
       Account ac = TestMethodUtility.createAccount();
       insert ac;
       
       Contact cont=TestMethodUtility.createContact(ac);
       cont.PS_Person_Id__c='67367332';
       insert cont;
       
       List<Contact_Role__c> Lcr = new List<Contact_Role__c>();
       
       Contact_Role__c cr1 =TestMethodUtility.createContactRole(ac);
       cr1.contact__c=u3.Contactid;
       cr1.Role__c='ANGEL - Admin';
       
       Contact_Role__c cr2 =TestMethodUtility.createContactRole(ac);
       cr2.Role__c='TRANSACT - Admin';
       cr2.contact__c=u3.Contactid;
       
       Contact_Role__c cr3 =TestMethodUtility.createContactRole(ac);
       cr3.Role__c='XYTHOS - Admin';
       cr3.contact__c=u3.Contactid;
       
       Contact_Role__c cr4 =TestMethodUtility.createContactRole(ac);
       cr4.Role__c='LEARN (CE/Vista) - Admin';
       cr4.contact__c=u3.Contactid;
       
       Contact_Role__c cr5 =TestMethodUtility.createContactRole(ac);
       cr5.Role__c='Moodlerooms - Admin';
       cr5.contact__c=u3.Contactid;
       
       Lcr.add(cr1);
       Lcr.add(cr2);
       Lcr.add(cr3);
       Lcr.add(cr4);
       Lcr.add(cr5);
       
       Insert Lcr;
       
        
        List<Core_License__c> Lcrr = new List<Core_License__c>();
        
        
       Core_License__c crr1 =TestMethodUtility.createCoreLicense();
       crr1.Name='ANGEL';
       
       Core_License__c crr2 =TestMethodUtility.createCoreLicense();
       crr2.Name='Transact';
       
       Core_License__c crr3 =TestMethodUtility.createCoreLicense();
       crr3.Name='Xythos';
       
       Core_License__c crr4 =TestMethodUtility.createCoreLicense();
       crr4.Name='CE';
       
       Core_License__c crr5 =TestMethodUtility.createCoreLicense();
       crr5.Name='Moodlerooms';
       
       
       
       
       Lcrr.add(crr1);
       Lcrr.add(crr2);
       Lcrr.add(crr3);
       Lcrr.add(crr4);
       Lcrr.add(crr5);
       
       insert Lcrr;
       
       Asset aset = TestMethodUtility.createAsset(ac,crr1);
       Insert aset;
       
       List<Case>   Lcase = new  List<Case>();
       Case cs1=TestMethodUtility.createCase1(ac,aset);
       cs1.Core_License__c=crr1.id;
       
       Case cs2=TestMethodUtility.createCase1(ac,aset);
       cs2.Core_License__c=crr2.id;
       
       Case cs3=TestMethodUtility.createCase1(ac,aset);
       cs3.Core_License__c=crr3.id;
       
       Case cs4=TestMethodUtility.createCase1(ac,aset);
       cs4.Core_License__c=crr4.id;
       
       Case cs5=TestMethodUtility.createCase1(ac,aset);
       cs5.Core_License__c=crr5.id;
       
       
       Lcase.add(cs1);
       Lcase.add(cs2);
       Lcase.add(cs3);
       Lcase.add(cs4);
       Lcase.add(cs5);
       
       Insert Lcase;
       
       
       
       
       
     System.runas(u3)
        {                
                           
        BtBbHomePageController home = new BtBbHomePageController();
           Test.starttest();
            home.selectedProduct='Learn'; 
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5();   
            home.selectedProduct='ANGEL'; 
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5();    
            home.selectedProduct=null;
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5();  
            Test.StopTest();
       

        BtBbHomePageController home1 = new BtBbHomePageController();  
        home1.Redirect(); 
        home1.selectedProduct='ANGEL'; 
        home1.recentArticles();
        system.assert(home.isLearnAcademicDeveloper==false);
        home.isLearnAcademicDeveloper=true;
      }  
    }  
   // this method has been written to excute Redirect method as Btbb profile 
    static testmethod void BtBbHomePageControllertest2(){
        
        /*
        Profile pf3= [select id from Profile where name = 'BTBB Profile'];
 
        User u3 = TestMethodUtility.createUser(pf3);
        u3.BTBB_KB_Default_Prod__c='ANGEL';
        insert u3;
        */
        Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];                  
        user u2 =[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];         
        contact c=[select PS_Person_Id__c from contact where id=:u2.contactId ];
        c.PS_Person_Id__c='abc173';
        update c;
        

        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
                
        Contact ct= TestMethodUtility.createContact(ac);
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
        
        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        insert cr;  
        
                
        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=c.Id;
        crr.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr;
        
        Contact_Role__c crr2 =TestMethodUtility.createContactRole(ac);
        crr2.CurrencyIsoCode='GBP';
        crr2.Expire_Role__c=False;
        crr2.Contact__c=u2.contactId;
        crr2.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr2;
        
        System.Runas(u2){
            
            BtBbHomePageController home = new BtBbHomePageController();  
            home.Redirect(); 
        }
        }
    
    static testmethod void UnitTestforCollabChanges(){
        
               
       User u3=[select id,contactid from user where contactid !=Null and isactive=True limit 1];
       
       Account ac = TestMethodUtility.createAccount();
       insert ac;
       
       Contact cont=TestMethodUtility.createContact(ac);
       cont.PS_Person_Id__c='67367332';
       insert cont;
       
       List<Contact_Role__c> Lcr = new List<Contact_Role__c>();
       
       Contact_Role__c cr1 =TestMethodUtility.createContactRole(ac);
       cr1.contact__c=u3.Contactid;
       cr1.Role__c='ANGEL - Admin';
       
       Contact_Role__c cr2 =TestMethodUtility.createContactRole(ac);
       cr2.Role__c='TRANSACT - Admin';
       cr2.contact__c=u3.Contactid;
       
       Contact_Role__c cr3 =TestMethodUtility.createContactRole(ac);
       cr3.Role__c='XYTHOS - Admin';
       cr3.contact__c=u3.Contactid;
       
       Contact_Role__c cr4 =TestMethodUtility.createContactRole(ac);
       cr4.Role__c='LEARN (CE/Vista) - Admin';
       cr4.contact__c=u3.Contactid;
       
       Contact_Role__c cr5 =TestMethodUtility.createContactRole(ac);
       cr5.Role__c='Moodlerooms - Admin';
       cr5.contact__c=u3.Contactid;
        
       
       Contact_Role__c cr6 =TestMethodUtility.createContactRole(ac);
       cr6.Role__c='COLLABORATE - System Admin';
       cr6.contact__c=u3.Contactid; 
        
       Contact_Role__c cr7 =TestMethodUtility.createContactRole(ac);
       cr7.Role__c='Collaborate - Admin';
       cr7.contact__c=u3.Contactid;  
       
       Lcr.add(cr1);
       Lcr.add(cr2);
       Lcr.add(cr3);
       Lcr.add(cr4);
       Lcr.add(cr5);
       Lcr.add(cr6);
       Lcr.add(cr7);
       
       Insert Lcr;
       
        
        List<Core_License__c> Lcrr = new List<Core_License__c>();
        
        
       Core_License__c crr1 =TestMethodUtility.createCoreLicense();
       crr1.Name='ANGEL';
       
       Core_License__c crr2 =TestMethodUtility.createCoreLicense();
       crr2.Name='Transact';
       
       Core_License__c crr3 =TestMethodUtility.createCoreLicense();
       crr3.Name='Xythos';
       
       Core_License__c crr4 =TestMethodUtility.createCoreLicense();
       crr4.Name='CE';
       
       Core_License__c crr5 =TestMethodUtility.createCoreLicense();
       crr5.Name='Moodlerooms';
       
       Core_License__c crr6 =TestMethodUtility.createCoreLicense();
       crr5.Name='Collaborate';
       
       
       Lcrr.add(crr1);
       Lcrr.add(crr2);
       Lcrr.add(crr3);
       Lcrr.add(crr4);
       Lcrr.add(crr5);
       Lcrr.add(crr6);
       
       insert Lcrr;
       
       Asset aset = TestMethodUtility.createAsset(ac,crr1);
       Insert aset;
       
       List<Case>   Lcase = new  List<Case>();
       Case cs1=TestMethodUtility.createCase1(ac,aset);
       cs1.Core_License__c=crr1.id;
       
       Case cs2=TestMethodUtility.createCase1(ac,aset);
       cs2.Core_License__c=crr2.id;
       
       Case cs3=TestMethodUtility.createCase1(ac,aset);
       cs3.Core_License__c=crr3.id;
       
       Case cs4=TestMethodUtility.createCase1(ac,aset);
       cs4.Core_License__c=crr4.id;
       
       Case cs5=TestMethodUtility.createCase1(ac,aset);
       cs5.Core_License__c=crr5.id;
        
       Case cs6=TestMethodUtility.createCase1(ac,aset);
       cs6.Core_License__c=crr6.id;
       
       
       Lcase.add(cs1);
       Lcase.add(cs2);
       Lcase.add(cs3);
       Lcase.add(cs4);
       Lcase.add(cs5);
       Lcase.add(cs6);
       Insert Lcase;
         BtBb_Announcement__c ancmnt= new BtBb_Announcement__c(Corelicense__c='Collaborate',Detail__c='test',TimeStamp__c=system.now(),Title__c='Collaboratetest',portal__c ='Authenticated',isactive__c=true);
         insert ancmnt;

        
        BtBbHomePageController home ;
       
        system.runas(u3)
        {
         home = new BtBbHomePageController();
         boolean collabreadonly =home.isCollabreadonly;
        list<btbb_link__c> servcelinks=home.SelfServicelinks;
        list<btbb_link__c> Communitylinks=home.communitylinks;
        home.selectedproduct='Collaborate';
        home.getannouncement();
        home.closeannouncement();
        home.getannouncement();
        }
        BtBb_Announcement__c ancmnt2= new BtBb_Announcement__c(Corelicense__c='Collaborate',Detail__c='test',TimeStamp__c=system.now().adddays(2),Title__c='Collaboratetest',portal__c ='Authenticated',isactive__c=true);
         insert ancmnt2;
         system.runas(u3)
        {
        list<btbb_link__c> servcelinks=home.SelfServicelinks;
        list<btbb_link__c> Communitylinks=home.communitylinks;
        home.selectedproduct='Collaborate';
        home.recentarticles();
        home.getannouncement();
        home.selectedproduct='Learn';
        home.getannouncement();
        home.selectedproduct='All';
         home.recentarticles();
        }
        
        Profile pf2= [select id from Profile where name = 'BTBB Profile'];  
        user guestsiteuser=[select id from user where profileid=:pf2.id and isactive=true limit 1];
        system.runas(guestsiteuser)
        {
        home = new BtBbHomePageController();
        home.Redirect();
        }
   }
    static testMethod void UnitTestAnalyticsPositiveScenario() {
       
        
        
        Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];                  
        user u4 =[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];         
        contact c=[select PS_Person_Id__c from contact where id=:u4.contactId ];
        c.PS_Person_Id__c='abc173';
        update c;
        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
                
        Contact ct= TestMethodUtility.createContact(ac);
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
        
        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Analytics';
        insert cr;  
        
                
        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=c.Id;
        crr.Role__c= 'ANALYTICS - Admin';
        
        insert crr;
        
             
    
       Asset a=TestMethodUtility.createAsset(ac,cr);
       a.Name='abc';
       a.Contact=ct;
       insert a;
    
      Case cs1=TestMethodUtility.createCase1(ac,a);
      cs1.Status='Solution Suggested';
      cs1.Description='this case has to be resolved';
      cs1.Type='abc';
      cs1.Subject='abc';
      cs1.Case_Severity__c='2';
      cs1.Primary_Group_Name__c='ANGEL - Development';
      cs1.Previous_Owner__c='yyyy';
      cs1.AccountId=ac.id;
      cs1.Contact=ct;
      cs1.Replication_in_the_Case__c = 'Test';
      insert cs1;
        
       
     
         System.runas(u4) {             
                           
        BtBbHomePageController home = new BtBbHomePageController();
        pageReference pageRedirect = new PageReference('http://en.wikipedia.org/wiki/Salesforce.com');
        pageRedirect.getParameters().put('returnURL',pageRedirect .getUrl());
        pageRedirect.setRedirect(true);
        home.Redirect();
        
        
           
           system.debug('Contact role--'+ [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u4.ContactID AND Expire_Role__c = false]);
            Test.StartTest();
            home = new BtBbHomePageController();          
            home.runFromTest = true;
            home.getRecentCases();
            home.getArticleCategories();
            
            home.selectedProduct='Analytics'; 
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5(); 
              
            Test.StopTest();
        }
    
    }
     
     static testMethod void UnitTestxpLorPositiveScenario() {
       
        
        
        Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];                  
        user u4 =[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];         
        contact c=[select PS_Person_Id__c from contact where id=:u4.contactId ];
        c.PS_Person_Id__c='abc173';
        update c;
        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
                
        Contact ct= TestMethodUtility.createContact(ac);
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
        
        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'xpLor';
        insert cr;  
        
                
        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=c.Id;
        crr.Role__c= 'XPLOR - Admin';
        
        insert crr;
        
             
    
       Asset a=TestMethodUtility.createAsset(ac,cr);
       a.Name='abc';
       a.Contact=ct;
       insert a;
    
      Case cs1=TestMethodUtility.createCase1(ac,a);
      cs1.Status='Solution Suggested';
      cs1.Description='this case has to be resolved';
      cs1.Type='abc';
      cs1.Subject='abc';
      cs1.Case_Severity__c='2';
      cs1.Primary_Group_Name__c='Learn - L2';
      cs1.Previous_Owner__c='yyyy';
      cs1.AccountId=ac.id;
      cs1.Contact=ct;
      cs1.Replication_in_the_Case__c = 'Test';
      insert cs1;
        
       
     
         System.runas(u4) {             
                           
        BtBbHomePageController home = new BtBbHomePageController();
        pageReference pageRedirect = new PageReference('http://en.wikipedia.org/wiki/Salesforce.com');
        pageRedirect.getParameters().put('returnURL',pageRedirect .getUrl());
        pageRedirect.setRedirect(true);
        home.Redirect();
        
        
           
            Test.StartTest();
            home = new BtBbHomePageController();
            home.selectedProduct='xpLor';          
            home.runFromTest = true;
            home.getRecentCases();
            home.getArticleCategories();
            
            home.selectedProduct='xpLor'; 
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            home.getURL5(); 
              
            Test.StopTest();
        }
    
    }
     


    }