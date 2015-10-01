@IsTest(SeeAllData=True)
Public Class ViewTaskTestClass
{
  static testMethod void myUnitTest1() 
  {
    Account acc = TestMethodUtility.createAccount();
    insert acc;
    
    contact c= TestMethodUtility.createContact(acc);
    insert c;
    
    contact c3= TestMethodUtility.createContact(acc);
    c3.Email='testmail@abc.com';
    insert c3;
     
    Product2 pr =TestMethodUtility.createProduct();
    pr.Type__c='Services';
    insert pr;
    
    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
    Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
    
    Opportunity op =TestMethodUtility.createOpportunity(acc,pb);
    insert op;
    
    PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
    pes.UseStandardPrice = false;
    insert pes;
    
    PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
    pe.UseStandardPrice = false;
    insert pe;
    
    OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli.OpportunityId=op.id;
    oli.Quantity=1; 
    insert oli;
    
    Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
    cr.Contact__c=c.id;
    cr.Role__c='ANALYTICS - Primary Sales Technical Contact';
    insert cr;
    
    Contact_Role__c cr2 = TestMethodUtility.createContactRole(acc);
    cr2.Contact__c=c3.id;
    cr2.Role__c='ANALYTICS - Primary Sales Contact';
    insert cr2;
    
    Contact_Role_Selector__c crs = TestMethodUtility.createContactRoleSelector(cr);
    crs.Opportunity__c=op.id;
    insert crs;
    
    Contact_Role_Selector__c crs2 = TestMethodUtility.createContactRoleSelector(cr2);
    crs2.Opportunity__c=op.id;
    insert crs2; 
    
    Profile p =[Select id from profile where name='SRV - Client Ops'];
    
    user u = TestMethodUtility.createUser(p);
    insert u;
     
    Custom_Task__c task = new Custom_Task__c();
    task.Opportunity__c = op.id;
    insert task;
    
    OpportunityTeamMember otm = new OpportunityTeamMember();
    otm.UserId=u.id;
    otm.OpportunityId=op.id;
    insert otm; 
    
    /*PageReference pageref = Page.FullfillmentViewProducts;  
    
    pageref.getParameters().put('id',task.id);
    ApexPages.StandardController stdController = new ApexPages.StandardController(task);
    ViewTasks viewtsk  = new ViewTasks(stdController);*/
    ApexPages.currentPage().getParameters().put('id',task.id);
    ViewTasks viewtsk = new ViewTasks(new ApexPages.StandardController (task));
    
    //ViewTasks viewtsk = new ViewTasks(new ApexPages.StandardController (task));
    viewtsk.SendMail();
    
    List<OpportunityLineItem> oppline;
    viewtsk.getOppline();
    
  } 
  
   static testMethod void myUnitTest3() 
   {
   Account acc = TestMethodUtility.createAccount();
    insert acc;
    
    contact c= TestMethodUtility.createContact(acc);
    insert c;
    
    contact c3= TestMethodUtility.createContact(acc);
    c3.Email='testmail@abc.com';
    insert c3;
     
    Product2 pr =TestMethodUtility.createProduct();
    pr.Type__c='Services';
    insert pr;
    
    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
    Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
    
    Opportunity op =TestMethodUtility.createOpportunity(acc,pb);
    
    ViewTasks viewtsk1 = new ViewTasks();
    
    Custom_Task__c task = new Custom_Task__c();
    insert task;
    
    ApexPages.currentPage().getParameters().put('id',task.id);
    
    ViewTasks ctr2 = new ViewTasks(new ApexPages.StandardController (task));
    //ctr2.SendMail();
   }
  
    static testMethod void myUnitTest2() {
    
    Account acc2 = TestMethodUtility.createAccount();
    insert acc2;
   
    Product2 pr2 =TestMethodUtility.createProduct();
    pr2.Type__c='Services';
    insert pr2;
    
    //Standard pricebook
    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
    Pricebook2 pb2 = [select Id from pricebook2 where Name='CPQ' limit 1];
    
    PricebookEntry pes2 = TestMethodUtility.createPricebookEntry(standardPB,pr2);
    pes2.UseStandardPrice = false;
    insert pes2;
    
    PricebookEntry pe2 = TestMethodUtility.createPricebookEntry(pb2,pr2);
    pe2.UseStandardPrice = false;
    insert pe2;
   
    Opportunity op2 =TestMethodUtility.createOpportunity(acc2,pb2);
    insert op2;
    
    Profile p =[Select id from profile where name='SRV - Client Ops'];
    
    user u = TestMethodUtility.createUser(p);
    insert u;
    
    
   
    Custom_Task__c task2 = new Custom_Task__c();
    task2.Opportunity__c = op2.id;
    insert task2;
    
    ApexPages.currentPage().getParameters().put('id',task2.id);
    
    ViewTasks ctr2 = new ViewTasks(new ApexPages.StandardController (task2));
    ctr2.SendMail();
   
    } 
    
   
}