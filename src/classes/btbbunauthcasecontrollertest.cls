@isTest
private class btbbunauthcasecontrollertest {
    
    static testmethod void myunittest(){
        
       PageReference page = new PageReference('/apex/btbb_unauthcase');
       Test.setCurrentPage(page);
        
       Account acc = TestMethodUtility.createAccount();
       acc.ownerid=userinfo.getuserid();
       insert acc;
       
       contact c= new contact(accountid=acc.id,lastname='test',email='test@123.com');
       insert c;
      
       Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
       insert cr;
       
       Core_License__c  core= TestMethodUtility.createCoreLicense();
       core.Name='Collaborate';           
       insert core;
       
       Module__c m = TestMethodUtility.createModule(core);
       insert m;
       
       EndUser__c e = new EndUser__c(Name = 'test',Email__c= 'test.ajith@gmail.com');
       insert e;
       
           
           btbbunauthcasecontroller ctr= New btbbunauthcasecontroller();
           
           ctr.name= null;
           ctr.saveObjects();
           ctr.name= 'test';
           ctr.EndUSerOrganization=null;
           ctr.saveObjects();
           ctr.EndUSerOrganization='widget university';
           ctr.saveObjects();
           ctr.email='test.ajith@gmail.com';
           ctr.actionFunMethod();
           ctr.saveObjects();
           ctr.reenteremail='test.ajith@gmail.com';
           ctr.saveObjects();
           ctr.ccemail='test1@abc.com;test2@abc.com;test3@abc.com;test5@abc.com;test4@abc.com';
           ctr.saveObjects();
           ctr.ccemail=null;
           ctr.phone='626916903';
           test.starttest();
           ctr.saveObjects();
           ctr.product ='test product';
           ctr.caserecord.End_User_Product__c='testproduct';
           ctr.saveObjects();
           ctr.module=m.id;
           ctr.saveObjects();
           ctr.subject='test';
           ctr.saveObjects();
           ctr.Description='test';
           ctr.saveObjects();
           ctr.getproductlists();
           ctr.getclos();
           ctr.getusrroleoptions();
           ctr.getbrowsop();
           ctr.getcmsoptions();
           ctr.changeproduct();
           ctr.caserecord.Core_License__c=core.id;
           List<selectOption> mtr=ctr.modules;
           ctr.email='test@123.com';
           ctr.actionFunMethod();
           test.stoptest();
          /* 
           ctr.usrrolevalue=null;
           ctr.saveObjects(); 
           ctr.email='test.com';
           ctr.saveObjects(); 
           ctr.email='test@gmail.com';
           ctr.saveObjects(); 
           
           ctr.reenteremail='utir@gmail.com';
           ctr.saveObjects(); 
           ctr.reenteremail='test@gmail.com';
           ctr.saveObjects(); 
           ctr.ccemail='test1@gmail.com;test2@gmail.com;test3@gmail.com;test4@gmail.com;test5@gmail.com;';
           ctr.saveObjects(); 
           ctr.phone=null;
           ctr.saveObjects(); 
           ctr.phone='+911111111111';
           ctr.saveObjects();
           test.starttest(); 
           ctr.product = NULL;
           ctr.saveObjects();
           ctr.module=m.ID;
           ctr.saveObjects(); 
           ctr.subject=NULL;
           ctr.saveObjects(); 
           ctr.subject='test';
           ctr.saveObjects();
           test.stoptest();  
           ctr.description=NULL;
           ctr.saveObjects(); 
           ctr.description='test';
           ctr.saveObjects();
           
           ctr.actionFunMethod();
           ctr.saveObjects();
           ctr.getclos();
           ctr.getusrroleoptions();
           ctr.getbrowsop();
           ctr.getcmsoptions();
           ctr.changeproduct();
           ctr.getproductlists();
           */
          
    }
 }