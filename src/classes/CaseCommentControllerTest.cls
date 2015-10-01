@istest
Private class CaseCommentControllerTest{

 private static testmethod void casecommenttest1(){
 
 Profile p1 = [select id,Name from Profile where Name='System Administrator'];
 User u = TestMethodUtility.createUser(p1);
 insert u;
 
 System.runas(u)
 {
 
   PageReference p = Page.CaseComment;
   Test.setCurrentPage(p);
   
   Account acc =TestMethodUtility.createAccount();
   insert acc;
   
   Contact cc=TestMethodUtility.createContact(acc);
   insert cc; 
   
   Core_License__c cr1=TestMethodUtility.createCoreLicense();
   insert cr1; 
   
   Asset ss = TestMethodUtility.createAsset(acc,cr1);
   insert ss;
   
   Case c=TestMethodUtility.createCase1(acc,ss);
   insert c;
   
   Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
    
    
    Case_Attachment__c ca = new Case_Attachment__c();
    ca.CurrencyIsoCode='GBP';
    ca.Case_Note__c=cn.id;
    ca.Related_To__c=c.id;
    ca.UserID__c =u.id;
    insert ca;
   
   
   ApexPages.CurrentPage().getParameters().Put('cid',c.id); 
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);
    Case_Attachment__c ca1 = new Case_Attachment__c();
    ca1.CurrencyIsoCode='GBP';
    ca1.Case_Note__c=cn.id;
    ca1.Related_To__c=c.id;
    ca1.UserID__c =u.id;
    insert ca1;
   list<casecommentcontroller.attachmentwrapper > s1 = controller.attachmentList;
   s1[0].attachToSI();
   controller.SelectedResponseOption = 'true';
   controller.Workflow='Close Case';
   controller.sendEmail=True;
   controller.CommentBody='Test';
   controller.ClosureReason = 'User Did Not Attend Training';
  // controller.getApiUser();
   controller.setErrorTitle(controller.getErrorTitle());
   controller.setErrorTitle2(controller.getErrorTitle2());
   controller.setErrorShow(controller.getErrorShow());
   controller.setErrorShow2(controller.getErrorShow2());
   controller.setErrorMessage(controller.getErrorMessage());
   controller.setErrorSeverity(controller.getErrorSeverity());
   controller.getdisplayAttach();
   controller.getCaseNoteAttachments();
   controller.getClosureReasons();
   controller.getWorkflow();
   controller.AddAttachment();
   controller.sendEmail=True;
   controller.evaluateWorkflow();
   List<selectOption> lo =controller.ResponseOptions;
   list<SelectOption>  ar=controller.Articles;
   list<SelectOption>  wrk=controller.Workflows;
   controller.getCaseID();
   controller.getCaseNumber();
   controller.getSubject();
   controller.getStatus();
   controller.getOwnerName();
   controller.getOwnerEmail();
   controller.getContactName();
   controller.getContactEmail();
   controller.Cancel();
   Test.starttest();
   controller.doSave();
   
   
    
   controller.Workflow='Suggest Solution';
   controller.evaluateWorkflow();
   controller.doSave();
   Test.stoptest();
  
 
   }
   }
  private static testmethod void casecommenttest2(){
 
 
 Profile p1 = [select id,Name from Profile where Name='System Administrator'];
 User u = TestMethodUtility.createUser(p1);
 insert u;
 
 System.runas(u)
 {
   PageReference p = Page.CaseComment;
   Test.setCurrentPage(p);
   Account acc =TestMethodUtility.createAccount();
   insert acc;
   Contact cc=TestMethodUtility.createContact(acc);
   insert cc; 
   
   Core_License__c cr1=TestMethodUtility.createCoreLicense();
   cr1.Name = 'Transact';
   insert cr1; 
   
   Asset ss = TestMethodUtility.createAsset(acc,cr1);
   insert ss;
   
   Case c=TestMethodUtility.createCase1(acc,ss);
   c.Case_Severity__c='3';
   insert c;
   
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
   
   
   ApexPages.CurrentPage().getParameters().Put('cid',c.id);
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);
  // controller.SelectedResponseOption = 'true';
   controller.Workflow='Close Case';
   controller.sendEmail=True;
   controller.ClosureReason = 'User Did Not Attend Training';
   controller.getApiUser();
   controller.setErrorTitle(controller.getErrorTitle());
   controller.setErrorTitle2(controller.getErrorTitle2());
   controller.setErrorShow(controller.getErrorShow());
   controller.setErrorShow2(controller.getErrorShow2());
   controller.setErrorMessage(controller.getErrorMessage());
   controller.setErrorSeverity(controller.getErrorSeverity());
   controller.getdisplayAttach();
   controller.getCaseNoteAttachments();
   controller.getClosureReasons();
   controller.getWorkflow();
   controller.AddAttachment();
   controller.sendEmail=True;
   List<selectOption> lo =controller.ResponseOptions;
   list<SelectOption>  ar=controller.Articles;
   list<SelectOption>  wrk=controller.Workflows;
   controller.getCaseID();
   controller.getCaseNumber();
   controller.getSubject();
   controller.getStatus();
   controller.getOwnerName();
   controller.getOwnerEmail();
   controller.getContactName();
   controller.getContactEmail();
   controller.Cancel();
   controller.evaluateWorkflow();
   test.starttest();
   controller.doSave();
   
  
   
   controller.Workflow='Update Client';
   controller.evaluateWorkflow();
   controller.doSave();
   
   Test.stoptest();
  
   } 
 }  
  private static testmethod void casecommenttest3(){
 
   Profile p1 = [select id,Name from Profile where Name='System Administrator'];
 User u = TestMethodUtility.createUser(p1);
 insert u;
 
 System.runas(u)
 {
  
   PageReference p = Page.CaseComment;
   Test.setCurrentPage(p);
   Account acc =TestMethodUtility.createAccount();
   insert acc;
   Contact cc=TestMethodUtility.createContact(acc);
   insert cc; 
   
   Core_License__c cr1=TestMethodUtility.createCoreLicense();
   cr1.Name = 'Xythos';
   insert cr1; 
   
   Asset ss = TestMethodUtility.createAsset(acc,cr1);
   insert ss;
   
   Case c=TestMethodUtility.createCase1(acc,ss);
   insert c;
   
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
   
   
   ApexPages.CurrentPage().getParameters().Put('cid',c.id);
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);
  // controller.SelectedResponseOption = 'true';
   controller.Workflow='Close Case';
   controller.sendEmail=True;
   controller.ClosureReason = 'User Did Not Attend Training';
   controller.getApiUser();
   controller.setErrorTitle(controller.getErrorTitle());
   controller.setErrorTitle2(controller.getErrorTitle2());
   controller.setErrorShow(controller.getErrorShow());
   controller.setErrorShow2(controller.getErrorShow2());
   controller.setErrorMessage(controller.getErrorMessage());
   controller.setErrorSeverity(controller.getErrorSeverity());
   controller.getdisplayAttach();
   controller.getCaseNoteAttachments();
   controller.getClosureReasons();
   controller.getWorkflow();
   controller.AddAttachment();
   controller.sendEmail=True;
   controller.evaluateWorkflow();
   List<selectOption> lo =controller.ResponseOptions;
   list<SelectOption>  ar=controller.Articles;
   list<SelectOption>  wrk=controller.Workflows;
   controller.getCaseID();
   controller.getCaseNumber();
   controller.getSubject();
   controller.getStatus();
   controller.getOwnerName();
   controller.getOwnerEmail();
   controller.getContactName();
   controller.getContactEmail();
   controller.Cancel();
   test.starttest();
   controller.doSave();
   
  
   
   controller.Workflow='Update Client';
   controller.evaluateWorkflow();
   controller.doSave();
   test.stoptest();
 
   }
  } 
  private static testmethod void casecommenttest4(){
 
  Profile p1 = [select id,Name from Profile where Name='System Administrator'];
 User u = TestMethodUtility.createUser(p1);
 insert u;
 
 System.runas(u)
 {
 
   PageReference p = Page.CaseComment;
   Test.setCurrentPage(p);
   Account acc =TestMethodUtility.createAccount();
   insert acc;
   Contact cc=TestMethodUtility.createContact(acc);
   insert cc; 
   
   Core_License__c cr1=TestMethodUtility.createCoreLicense();
   cr1.Name = 'Abc';
   insert cr1; 
   
   Asset ss = TestMethodUtility.createAsset(acc,cr1);
   insert ss;
   
   Case c=TestMethodUtility.createCase1(acc,ss);
   insert c;
   
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
   
   
   ApexPages.CurrentPage().getParameters().Put('cid',c.id);
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);
  //controller.SelectedResponseOption = 'true';
 
   controller.sendEmail=True;
   controller.ClosureReason = 'User Did Not Attend Training';
   test.starttest();
   controller.doSave();
   controller.Workflow='Close Case';
   controller.Cancel();
   controller.doSave();
    test.stoptest(); 
  
   } 
  }  
 // Added By Nikhil to add some more methods
 private static testmethod void casecommenttest5(){
 
 Profile p1 = [select id,Name from Profile where Name='System Administrator'];
 User u = TestMethodUtility.createUser(p1);
 insert u;
 
 System.runas(u)
 {
 
   PageReference p = Page.CaseComment;
   Test.setCurrentPage(p);
   Account acc =TestMethodUtility.createAccount();
   insert acc;
   Contact cc=TestMethodUtility.createContact(acc);
   insert cc; 
   
   Core_License__c cr1=TestMethodUtility.createCoreLicense();
   cr1.Name = 'Abc';
   insert cr1; 
   
   Asset ss = TestMethodUtility.createAsset(acc,cr1);
   insert ss;
   
   Case c=TestMethodUtility.createCase1(acc,ss);
   insert c;
   
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
   
   
   ApexPages.CurrentPage().getParameters().Put('cid',c.id);
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);
  
 
   controller.sendEmail=True;
   controller.ClosureReason = 'User Did Not Attend Training';
   test.starttest();
   controller.sendEmailCustomer =True;
   controller.sendEmailInternal =True;
   controller.displayCannedResponse();
   controller.actionFunMethod();
  // controller.sendmail();
   test.stoptest(); 
  
   } 
  }

  static testmethod void UnitTestAnalyticsPositiveScenarios(){
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
    System.runAs(sysuser){

    PageReference p = Page.CaseComment;
   Test.setCurrentPage(p);
   Account acc =TestMethodUtility.createAccount();
   insert acc;
   Contact cc=TestMethodUtility.createContact(acc);
   insert cc; 
   
   Core_License__c cr1=TestMethodUtility.createCoreLicense();
   cr1.Name = 'Analytics';
   insert cr1; 
   
   Asset ss = TestMethodUtility.createAsset(acc,cr1);
   insert ss;
   
   Case c=TestMethodUtility.createCase1(acc,ss);
   insert c;
   
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
   
   
   ApexPages.CurrentPage().getParameters().Put('cid',c.id);
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);
  // controller.SelectedResponseOption = 'true';
   controller.Workflow='Close Case';
   controller.sendEmail=True;
   controller.ClosureReason = 'User Did Not Attend Training';
   controller.getApiUser();
   controller.setErrorTitle(controller.getErrorTitle());
   controller.setErrorTitle2(controller.getErrorTitle2());
   controller.setErrorShow(controller.getErrorShow());
   controller.setErrorShow2(controller.getErrorShow2());
   controller.setErrorMessage(controller.getErrorMessage());
   controller.setErrorSeverity(controller.getErrorSeverity());
   controller.getdisplayAttach();
   controller.getCaseNoteAttachments();
   controller.getClosureReasons();
   controller.getWorkflow();
   controller.AddAttachment();
   controller.sendEmail=True;
   controller.evaluateWorkflow();
   List<selectOption> lo =controller.ResponseOptions;
   list<SelectOption>  ar=controller.Articles;
   list<SelectOption>  wrk=controller.Workflows;
   controller.getCaseID();
   controller.getCaseNumber();
   controller.getSubject();
   controller.getStatus();
   controller.getOwnerName();
   controller.getOwnerEmail();
   controller.getContactName();
   controller.getContactEmail();
   controller.Cancel();
   test.starttest();
   controller.doSave();
   
  
   
   controller.Workflow='Update Client';
   controller.evaluateWorkflow();
   controller.doSave();
   test.stoptest();

    }

  }
  static testmethod void UnitTestxplorPositiveScenarios()
  {
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];

    Account acc =TestMethodUtility.createAccount();
    insert acc;

    Contact cc = TestMethodUtility.createContact(acc);
    insert cc; 
   
    Core_License__c cr1=TestMethodUtility.createCoreLicense();
    cr1.Name = 'xpLor';
    insert cr1; 
   
    Asset ss = TestMethodUtility.createAsset(acc,cr1);
    insert ss;
   
    Case c=TestMethodUtility.createCase1(acc,ss);
    insert c;
   
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=c.id;
    cn.Contact__c=cc.id;
    cn.PS_Note_Seq_Nbr__c='12345';
    cn.Type__c='Test';
    insert cn;

    PageReference p = Page.CaseComment;
    Test.setCurrentPage(p);

    ApexPages.CurrentPage().getParameters().Put('cid',c.id);
   ApexPages.StandardController cont = new ApexPages.StandardController(cn);
   CaseCommentController controller = new CaseCommentController (cont);

   controller.Workflow='Close Case';
   controller.sendEmail=True;
   controller.ClosureReason = 'User Did Not Attend Training';
   controller.getApiUser();
   controller.setErrorTitle(controller.getErrorTitle());
   controller.setErrorTitle2(controller.getErrorTitle2());
   controller.setErrorShow(controller.getErrorShow());
   controller.setErrorShow2(controller.getErrorShow2());
   controller.setErrorMessage(controller.getErrorMessage());
   controller.setErrorSeverity(controller.getErrorSeverity());
   controller.getdisplayAttach();
   controller.getCaseNoteAttachments();
   controller.getClosureReasons();
   controller.getWorkflow();
   controller.AddAttachment();
   controller.sendEmail=True;
   controller.evaluateWorkflow();
   List<selectOption> lo =controller.ResponseOptions;
   list<SelectOption>  ar=controller.Articles;
   list<SelectOption>  wrk=controller.Workflows;
   controller.getCaseID();
   controller.getCaseNumber();
   controller.getSubject();
   controller.getStatus();
   controller.getOwnerName();
   controller.getOwnerEmail();
   controller.getContactName();
   controller.getContactEmail();
   controller.Cancel();
   test.starttest();
   controller.doSave();
   
  
   
   controller.Workflow='Update Client';
   controller.evaluateWorkflow();
   controller.doSave();
   test.stoptest();

   }  

 }