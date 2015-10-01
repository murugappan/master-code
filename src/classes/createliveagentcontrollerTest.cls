// Created By Nikhil
// Date:-15/05/2014

@isTest
private class createliveagentcontrollerTest {
    static testmethod void testmethod1()
    {
       Account ac=TestMethodUtility.createAccount();
       insert ac;
       
       Contact c = TestMethodUtility.createContact(ac);
       c.PS_Person_Id__c='98984573';
       insert c;

      
       
      
       
       // List of Core license
       List<Core_License__c> Lcore = New  List<Core_License__c>();
       Core_License__c core1 = TestMethodUtility.createCoreLicense();
       core1.Name='Collaborate';
       core1.Product__c='Diploma';
       
       Core_License__c core2 = TestMethodUtility.createCoreLicense();
       core2.Name='Collaborate';
       core2.Product__c='Blackboard IM';
       
       Core_License__c core3 = TestMethodUtility.createCoreLicense();
       core3.Name='Collaborate';
       core3.Product__c=' Diploma';
       
       Core_License__c core4 = TestMethodUtility.createCoreLicense();
       core4.Name='Collaborate';
       core4.Product__c='Voice Authoring';
       
       Core_License__c core5 = TestMethodUtility.createCoreLicense();
       core5.Name='Collaborate';
       core5.Product__c='Web Conferencing';
       
       Core_License__c core6 = TestMethodUtility.createCoreLicense();
       core6.Name='Collaborate';
       core6.Product__c='Wimba Classroom';
       
       Lcore.add(core1);
       Lcore.add(core2);
       Lcore.add(core3);
       Lcore.add(core4);
       Lcore.add(core5);
       Lcore.add(core6);
       
       Insert  Lcore;
       
       Module__c m = TestMethodUtility.createModule(core5);
       m.Name='SAS';
       insert m;
       
       Functional_Area__c fa = TestMethodUtility.createFunctionalArea(m);
       insert fa;
       
       Category__c cg = TestMethodUtility.createCategory(fa);
       insert cg;
       
       EndUser__c e = new EndUser__c(Name = 'test',Email__c= 'test.ajith@gmail.com');
       insert e;
       
       ChatCase__c chatcase=TestMethodUtility.CreatechatCase();
       chatcase.Account__c=ac.id;
       chatcase.product__c='SAS';
       Insert chatcase;
       
       case cs = TestMethodUtility.createCase(c,core5,ac,m);
       cs.ContactId = null;
       cs.ChatCase__c = chatcase.id;
       cs.End_User_Product__c='SAS';
       cs.Core_License__c=core5.id;
       insert cs;
       
       
       Apexpages.Currentpage().getParameters().put('chatid',chatcase.id);  
       ApexPages.StandardController cont = New ApexPages.StandardController(cs);
       createliveagentcontroller controller = new createliveagentcontroller(cont);
       
       controller.changeproduct();
       controller.savecase(); 
       controller.functionalarea=fa.id; 
       List<selectOption> lOp=controller.modules;
       List<selectOption> lOp1=controller.functionalareas;
       List<selectOption> lOp2=controller.categories;
       
       controller.savecase();
       cs.Subject='test failure';
       Test.StartTest();
       controller.savecase();
       cs.Description='Test Description';
       controller.savecase();
       cs.Accountid=null;
       controller.savecase();
       cs.Accountid=ac.id;
       cs.End_User__c =Null;
       controller.enduseridboolean=false; 
       controller.savecase();
       chatcase.Account__c=Null;
       update chatcase;
       ApexPages.StandardController cont1 = New ApexPages.StandardController(cs);
       createliveagentcontroller controller1 = new createliveagentcontroller(cont1);
       Test.StopTest();
    }
     static testmethod void testmethod2()
    {
       Account ac=TestMethodUtility.createAccount();
       insert ac;
       
       Contact c = TestMethodUtility.createContact(ac);
       c.PS_Person_Id__c='98984573';
       insert c;

       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate'; 
       core.Product__c='Test';          
       insert core;
       
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       
       Functional_Area__c fa = TestMethodUtility.createFunctionalArea(m);
       insert fa;
       
       Category__c cg = TestMethodUtility.createCategory(fa);
       insert cg;
       
       EndUser__c chatcase=TestMethodUtility.CreateEndUser();
       chatcase.Account__c=ac.id;
       chatcase.Email__c='nikhil886846@gmail.com';
       Insert chatcase;
       
       // List of Core license
       List<Core_License__c> Lcore = New  List<Core_License__c>();
       Core_License__c core1 = TestMethodUtility.createCoreLicense();
       core1.Name='Collaborate';
       core1.Product__c='Diploma';
       
       Core_License__c core2 = TestMethodUtility.createCoreLicense();
       core2.Name='Collaborate';
       core2.Product__c='Blackboard IM';
       
       Core_License__c core3 = TestMethodUtility.createCoreLicense();
       core3.Name='Collaborate';
       core3.Product__c=' Diploma';
       
       Core_License__c core4 = TestMethodUtility.createCoreLicense();
       core4.Name='Collaborate';
       core4.Product__c='Voice Authoring';
       
       Core_License__c core5 = TestMethodUtility.createCoreLicense();
       core5.Name='Collaborate';
       core5.Product__c='Web Conferencing';
       
       Core_License__c core6 = TestMethodUtility.createCoreLicense();
       core6.Name='Collaborate';
       core6.Product__c='Wimba Classroom';
       
       Lcore.add(core1);
        Lcore.add(core2);
         Lcore.add(core3);
          Lcore.add(core4);
           Lcore.add(core5);
            Lcore.add(core6);
       
       Insert  Lcore;
       
       
       case cs = TestMethodUtility.createCase(c,core,ac,m);
       cs.ContactId = null;
       cs.End_User__c = chatcase.id;
       cs.End_User_Product__c='Plan';
       insert cs;
       
      
       
       Apexpages.Currentpage().getParameters().put('enduserid',chatcase.id);  
       ApexPages.StandardController cont = New ApexPages.StandardController(cs);
       createliveagentcontroller controller = new createliveagentcontroller(cont);
       
     //  controller.changeproduct();
       controller.savecase(); 
    
    }
    static testmethod void testmethod3()
    {
       Account ac=TestMethodUtility.createAccount();
       insert ac;
       
       Contact c = TestMethodUtility.createContact(ac);
       c.PS_Person_Id__c='98984573';
       insert c;

      
       
      
       
       // List of Core license
       List<Core_License__c> Lcore = New  List<Core_License__c>();
       Core_License__c core1 = TestMethodUtility.createCoreLicense();
       core1.Name='Collaborate';
       core1.Product__c='Diploma';
       
       Core_License__c core2 = TestMethodUtility.createCoreLicense();
       core2.Name='Collaborate';
       core2.Product__c='Blackboard IM';
       
       Core_License__c core3 = TestMethodUtility.createCoreLicense();
       core3.Name='Collaborate';
       core3.Product__c=' Diploma';
       
       Core_License__c core4 = TestMethodUtility.createCoreLicense();
       core4.Name='Collaborate';
       core4.Product__c='Voice Authoring';
       
       Core_License__c core5 = TestMethodUtility.createCoreLicense();
       core5.Name='Collaborate';
       core5.Product__c='Web Conferencing';
       
       Core_License__c core6 = TestMethodUtility.createCoreLicense();
       core6.Name='Collaborate';
       core6.Product__c='Wimba Classroom';
       
       Lcore.add(core1);
        Lcore.add(core2);
         Lcore.add(core3);
          Lcore.add(core4);
           Lcore.add(core5);
            Lcore.add(core6);
       
       Insert  Lcore;
       
       Module__c m = TestMethodUtility.createModule(core5);
       m.Name='SAS';
       insert m;
       
       Functional_Area__c fa = TestMethodUtility.createFunctionalArea(m);
       insert fa;
       
       Category__c cg = TestMethodUtility.createCategory(fa);
       insert cg;
       
       EndUser__c e = new EndUser__c(Name = 'test',Email__c= 'test.ajith@gmail.com');
       insert e;
       
       ChatCase__c chatcase=TestMethodUtility.CreatechatCase();
       chatcase.Account__c=ac.id;
       chatcase.product__c='SAS';
       Insert chatcase;
       
       case cs = TestMethodUtility.createCase(c,core5,ac,m);
       cs.ContactId = null;
       cs.ChatCase__c = chatcase.id;
       cs.End_User_Product__c='SAS';
       cs.Core_License__c=core5.id;
       insert cs;
       
       
       Apexpages.Currentpage().getParameters().put('chatid',chatcase.id);  
       ApexPages.StandardController cont = New ApexPages.StandardController(cs);
       createliveagentcontroller controller = new createliveagentcontroller(cont);
       
       controller.changeproduct();
       controller.saveandgrabcase(); 
       controller.functionalarea=fa.id; 
       List<selectOption> lOp=controller.modules;
       List<selectOption> lOp1=controller.functionalareas;
       List<selectOption> lOp2=controller.categories;
       
       controller.saveandgrabcase();
       cs.Subject='test failure';
       Test.StartTest();
       controller.saveandgrabcase();
       cs.Description='Test Description';
       controller.saveandgrabcase();
       cs.Accountid=null;
       controller.saveandgrabcase();
       cs.Accountid=ac.id;
       cs.End_User__c =Null;
       controller.enduseridboolean=false; 
       controller.saveandgrabcase();
       chatcase.Account__c=Null;
       update chatcase;
       ApexPages.StandardController cont1 = New ApexPages.StandardController(cs);
       createliveagentcontroller controller1 = new createliveagentcontroller(cont1);
       Test.StopTest();
    }
     static testmethod void testmethod4()
    {
       Account ac=TestMethodUtility.createAccount();
       insert ac;
       
       Contact c = TestMethodUtility.createContact(ac);
       c.PS_Person_Id__c='98984573';
       insert c;

       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate'; 
       core.Product__c='Test';          
       insert core;
       
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       
       Functional_Area__c fa = TestMethodUtility.createFunctionalArea(m);
       insert fa;
       
       Category__c cg = TestMethodUtility.createCategory(fa);
       insert cg;
       
       EndUser__c chatcase=TestMethodUtility.CreateEndUser();
       chatcase.Account__c=ac.id;
       chatcase.Email__c='nikhil886846@gmail.com';
       Insert chatcase;
       
       // List of Core license
       List<Core_License__c> Lcore = New  List<Core_License__c>();
       Core_License__c core1 = TestMethodUtility.createCoreLicense();
       core1.Name='Collaborate';
       core1.Product__c='Diploma';
       
       Core_License__c core2 = TestMethodUtility.createCoreLicense();
       core2.Name='Collaborate';
       core2.Product__c='Blackboard IM';
       
       Core_License__c core3 = TestMethodUtility.createCoreLicense();
       core3.Name='Collaborate';
       core3.Product__c=' Diploma';
       
       Core_License__c core4 = TestMethodUtility.createCoreLicense();
       core4.Name='Collaborate';
       core4.Product__c='Voice Authoring';
       
       Core_License__c core5 = TestMethodUtility.createCoreLicense();
       core5.Name='Collaborate';
       core5.Product__c='Web Conferencing';
       
       Core_License__c core6 = TestMethodUtility.createCoreLicense();
       core6.Name='Collaborate';
       core6.Product__c='Wimba Classroom';
       
       Lcore.add(core1);
        Lcore.add(core2);
         Lcore.add(core3);
          Lcore.add(core4);
           Lcore.add(core5);
            Lcore.add(core6);
       
       Insert  Lcore;
       
       
       case cs = TestMethodUtility.createCase(c,core,ac,m);
       cs.ContactId = null;
       cs.End_User__c = chatcase.id;
       cs.End_User_Product__c='Plan';
       insert cs;
       
      
       Apexpages.Currentpage().getParameters().put('enduserid',chatcase.id);  
       ApexPages.StandardController cont = New ApexPages.StandardController(cs);
       createliveagentcontroller controller = new createliveagentcontroller(cont);
       
     //  controller.changeproduct();
       controller.saveandgrabcase(); 
       
    }
    static testmethod void testmethod5(){
    
       Profile p = [select id from Profile where name = 'SRV - System Administrator'];
       User u1 = TestMethodUtility.createUser(p);
       u1.Primary_Group__c = 'Collaborate: Tier 1 Support';
       insert u1; 
       
     system.runas(u1){
     Account ac=TestMethodUtility.createAccount();
       insert ac;
       
       Contact c = TestMethodUtility.createContact(ac);
       c.PS_Person_Id__c='98984573';
       insert c;

       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate'; 
       core.Product__c='Test';          
       insert core;
       
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       
       Functional_Area__c fa = TestMethodUtility.createFunctionalArea(m);
       insert fa;
       
       Category__c cg = TestMethodUtility.createCategory(fa);
       insert cg;
       
       EndUser__c chatcase=TestMethodUtility.CreateEndUser();
       chatcase.Account__c=ac.id;
       chatcase.Email__c='nikhil886846@gmail.com';
       Insert chatcase;
       
       // List of Core license
       List<Core_License__c> Lcore = New  List<Core_License__c>();
       Core_License__c core1 = TestMethodUtility.createCoreLicense();
       core1.Name='Collaborate';
       core1.Product__c='Diploma';
       
       Core_License__c core2 = TestMethodUtility.createCoreLicense();
       core2.Name='Collaborate';
       core2.Product__c='Blackboard IM';
       
       Core_License__c core3 = TestMethodUtility.createCoreLicense();
       core3.Name='Collaborate';
       core3.Product__c=' Diploma';
       
       Core_License__c core4 = TestMethodUtility.createCoreLicense();
       core4.Name='Collaborate';
       core4.Product__c='Voice Authoring';
       
       Core_License__c core5 = TestMethodUtility.createCoreLicense();
       core5.Name='Collaborate';
       core5.Product__c='Web Conferencing';
       
       Core_License__c core6 = TestMethodUtility.createCoreLicense();
       core6.Name='Collaborate';
       core6.Product__c='Wimba Classroom';
       
       Lcore.add(core1);
        Lcore.add(core2);
         Lcore.add(core3);
          Lcore.add(core4);
           Lcore.add(core5);
            Lcore.add(core6);
       
       Insert  Lcore;
       
       
       case cs = TestMethodUtility.createCase(c,core,ac,m);
       cs.ContactId = null;
       cs.End_User__c = chatcase.id;
       cs.End_User_Product__c='Plan';
       insert cs;
       
      
       Apexpages.Currentpage().getParameters().put('enduserid',chatcase.id);
       Apexpages.Currentpage().getParameters().put('id',cs.id);    
       ApexPages.StandardController cont = New ApexPages.StandardController(cs);
       createliveagentcontroller controller = new createliveagentcontroller(cont);
       
     
       controller.saveandgrabcase(); 
       
         
        
     }
       
    }
       
    
  }