/* Created by Varghese George
 *Created on 14 may 2014
 */
 @istest(seealldata=True)
 private class btbbInstitutionControllertest{
 
  static testmethod void unittest1()
  {
   User u3=[select id,contactid from user where contactid !=Null and isactive=True limit 1];
   User u4=[Select id from  user where isactive=True and Profile.Name='System Administrator' limit 1];
        Account ac = TestMethodUtility.createAccount();
       insert ac;
       
        Account ac2 = TestMethodUtility.createAccount();
       insert ac2;
       
       Contact cont=TestMethodUtility.createContact(ac);
       cont.Preferred_Institution__c=ac.id;
       cont.PS_Person_Id__c='67367332';
       insert cont;
       
       List<Contact_Role__c> Lcr = new List<Contact_Role__c>();
       
       Contact_Role__c cr1 =TestMethodUtility.createContactRole(ac);
       cr1.contact__c=cont.id;
       cr1.Role__c='ANGEL - Admin';
       
       Contact_Role__c cr2 =TestMethodUtility.createContactRole(ac);
       cr2.Role__c='TRANSACT - Admin';
       cr2.contact__c=cont.id;
       
       Contact_Role__c cr3 =TestMethodUtility.createContactRole(ac);
       cr3.Role__c='XYTHOS - Admin';
       cr3.contact__c=u3.Contactid;
       
       Contact_Role__c cr4 =TestMethodUtility.createContactRole(ac2);
       cr4.Role__c='LEARN (CE/Vista) - Admin';
       cr4.contact__c=cont.id;
       
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
       crr1.Name='Learn';
       
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
       
       
        product2 prod=[select id,GKEY_Product_Group__c  from product2 where GKEY_Product_Group__c != null and isactive=true limit 1] ;
        
        Asset aset1 = new Asset();
        aset1.Name = 'Test Asset 111';
        aset1.Core_License__c = crr1.ID;
        aset1.AccountID = ac.ID;
        aset1.Installed_Product_ID__c = '123';
        aset1.Status = 'Installed'; 
        aset1.version__c = '9.1';
        aset1.Psft_Product_Id__c = 'AS-LS';
        aset1.Version_Build__c = '9.1.X';
        aset1.Force_Btbb_Visibility__c = true ;
        aset1.product2id=prod.id;
        insert aset1;

        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = crr5.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578MR';
        aset2.Status = 'Installed'; 
        aset2.version__c = '9.1';
        aset2.Psft_Product_Id__c = 'AS-LS-MR34';
        aset2.Version_Build__c = '9.1.X';
        aset2.Software_URL__c='www.mr.com';
        aset2.Force_Btbb_Visibility__c = true ;
        aset2.product2id=prod.id;
        insert aset2;
        
        version_build_tree__c vr1=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.110',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr1;
        version_build_tree__c vr2=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.220',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr2;
        version_build_tree__c vr3=new version_build_tree__c(Version__c='9.2',Version_Build__c='10.2.220',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr3;
       system.runas(u3)
       {
        PageReference pageRef = Page.btbb_myinstitution;
        pageref.getparameters().put('id',ac.id);
        pageref.getparameters().put('cid',cont.id);
        pageref.getparameters().put('AssetUpdate',aset1.id);
        test.setcurrentpage(pageref);
        btbbInstitutionController controller=new btbbInstitutionController();
        controller.getuserid();
        controller.getBbAccountReps();
        controller.getDatabaseList();
        controller.getDbServerOS1();
        controller.getJDKVersionList();
        controller.getApplServerOS();
        controller.getContactData();

        list<btbbInstitutionController.assetwrapper> ast=controller.AssetData ;
        boolean test1=controller.getaccstat();
        boolean test2=controller.isAccontSel;
        controller.selectAccount() ;
        controller.EditAsset() ;
        controller.SaveAsset();
        
        controller.CancelAsset();
        controller.assetid=aset1.id;
        list<selectoption> version=controller.versions;
        controller.version='9.2';
        controller.build='9.0.2';
        test.starttest();
        list<selectoption>sblist=controller.sblist;
        boolean test3=controller.isDeveloper;
        boolean test4=controller.isMLAAdmin;
        controller.SaveAsset();
        controller.assetid=aset2.id;
        controller.version='9.1';
        controller.build='9.0.3';
        controller.Saveasset();
        controller.Redirect();
        
        
       }
        Profile pf2= [select id from Profile where name = 'BTBB Profile'];  
        user guestsiteuser=[select id from user where profileid=:pf2.id and isactive=true limit 1];
        btbbInstitutionController controller;
        system.runas(guestsiteuser)
        {
        controller= new btbbInstitutionController();
        controller.Redirect();
        }
        test.stoptest();
   
  }
 static testMethod void UnitTestAnalyticsPositiveScenarios(){
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     system.runAs(sysuser){

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont =TestMethodUtility.createContact(ac);
        cont.FirstName='';
        cont.LastName='contact LastName';
        cont.AccountId=ac.id;
        cont.Contact_Status__c='Active';
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
        crr.Expire_Role__c=false;
        crr.Account__c=ac.id;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'ANALYTICS - Admin';
        
        insert crr;
        product2 prod=[select id,GKEY_Product_Group__c  from product2 where GKEY_Product_Group__c != null and isactive=true limit 1] ;
        

        

        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = cr.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578MR';
        aset2.Status = 'Installed'; 
        aset2.version__c = '9.1';
        aset2.Psft_Product_Id__c = 'AS-LS-MR34';
        aset2.Version_Build__c = '9.1.X';
        aset2.Software_URL__c='www.mr.com';
        aset2.Force_Btbb_Visibility__c = true ;
        aset2.product2id=prod.id;
        insert aset2;
        
        version_build_tree__c vr1=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.110',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr1;

        system.runAs(u){

        PageReference pageRef = Page.btbb_myinstitution;
        pageref.getparameters().put('id',ac.id);
        pageref.getparameters().put('cid',cont.id);
        test.setcurrentpage(pageref);
        btbbInstitutionController controller=new btbbInstitutionController();
        controller.getContactData();
        controller.clearsb();
        
      }
     
     }

 }
  static testMethod void UnitTestxpLorPositiveScenarios(){
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     system.runAs(sysuser){

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont =TestMethodUtility.createContact(ac);
        cont.FirstName='';
        cont.LastName='contact LastName'; 
        cont.AccountId=ac.id;
        cont.Contact_Status__c='Active';
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'xpLor';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=false;
        crr.Account__c=ac.id;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'XPLOR - Admin';
        
        insert crr;
        product2 prod=[select id,GKEY_Product_Group__c  from product2 where GKEY_Product_Group__c != null and isactive=true limit 1] ;
        

        

        Asset aset2 = new Asset();
        aset2.Name = 'Test Asset MR 111';
        aset2.Core_License__c = cr.ID;
        aset2.AccountID = ac.ID;
        aset2.Installed_Product_ID__c = '123578MR';
        aset2.Status = 'Installed'; 
        aset2.version__c = '9.1';
        aset2.Psft_Product_Id__c = 'AS-LS-MR34';
        aset2.Version_Build__c = '9.1.X';
        aset2.Software_URL__c='www.mr.com';
        aset2.Force_Btbb_Visibility__c = true ;
        aset2.product2id=prod.id;
        insert aset2;
        
        version_build_tree__c vr1=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.110',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr1;

        system.runAs(u){

        PageReference pageRef = Page.btbb_myinstitution;
        pageref.getparameters().put('id',ac.id);
        pageref.getparameters().put('cid',cont.id);
        test.setcurrentpage(pageref);
        btbbInstitutionController controller=new btbbInstitutionController();
        controller.getContactData();
        controller.clearsb();
        
      }
     
     }

 }
 }