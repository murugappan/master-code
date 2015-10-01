@isTest(SeeAllData=True)
public class FullfillmentMyTeamTasksTest {
    static testMethod void myUnitTest() {

    Account acc = TestMethodUtility.createAccount();
    insert acc;
    
    List<Contact> con = new List<Contact>();
    
    contact c= TestMethodUtility.createContact(acc);
    con.add(c);
    
    contact c1= TestMethodUtility.createContact(acc);
    c1.Email='testmail@abc.com';
    con.add(c1);
    //insert c1;
    
    insert con;
    
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
    
    List<Contact_Role__c> lcr = new List<Contact_Role__c>();
    
    Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
    cr.Contact__c= con[0].id;
    cr.Role__c='ANALYTICS - Primary Sales Technical Contact';
    lcr.add(cr);
    //insert cr;
    
    Contact_Role__c cr2 = TestMethodUtility.createContactRole(acc);
    cr2.Contact__c= con[1].id;
    cr2.Role__c='ANALYTICS - Primary Sales Contact';
    lcr.add(cr2);
    //insert cr2;
    insert lcr;
    
    List<Contact_Role_Selector__c> Lcrs = new List<Contact_Role_Selector__c>();
    Contact_Role_Selector__c crs = TestMethodUtility.createContactRoleSelector(cr);
    crs.Opportunity__c=op.id;
    Lcrs.add(crs);
    //insert crs;
    
    Contact_Role_Selector__c crs2 = TestMethodUtility.createContactRoleSelector(cr2);
    crs2.Opportunity__c=op.id;
    Lcrs.add(crs2);
    //insert crs2; 
    insert Lcrs;
    
    
    Profile p =[Select id from profile where name='System Administrator'];
    
    User u = TestMethodUtility.createUser(p);
    insert u;

    OpportunityTeamMember otm = new OpportunityTeamMember();
    otm.UserId=u.id;
    otm.OpportunityId=op.id;
    insert otm;  
    
    Custom_Task__c task = new Custom_Task__c();
    task.Opportunity__c = op.id;
    insert task;
                 
    FullfilmentTaskdemo f1 = new FullfilmentTaskdemo(new ApexPages.StandardController (task));
  
    String sortExpression ='';
    String sortExp='name';
    String sortDirection='DESC';
    f1.sortExpression=sortExp;
    f1.setSortDirection('ASC');
    f1.getSortDirection();
    
    f1.sortExpression='';
    f1.getSortDirection();
    }
 
    static testMethod void myUnitTest2() {

    Account acc = TestMethodUtility.createAccount();
    insert acc;
    
    List<Contact> con = new List<Contact>();
    
    contact c= TestMethodUtility.createContact(acc);
    con.add(c);
    
    contact c1= TestMethodUtility.createContact(acc);
    c1.Email='testmail@abc.com';
    con.add(c1);
    //insert c1;
    
    insert con;
     
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
    
   List<Contact_Role__c> lcr = new List<Contact_Role__c>();
    
    Contact_Role__c cr = TestMethodUtility.createContactRole(acc);
    cr.Contact__c= con[0].id;
    cr.Role__c='ANALYTICS - Primary Sales Technical Contact';
    lcr.add(cr);
    //insert cr;
    
    Contact_Role__c cr2 = TestMethodUtility.createContactRole(acc);
    cr2.Contact__c= con[1].id;
    cr2.Role__c='ANALYTICS - Primary Sales Contact';
    lcr.add(cr2);
    //insert cr2;
    insert lcr;
    
    List<Contact_Role_Selector__c> Lcrs = new List<Contact_Role_Selector__c>();
    Contact_Role_Selector__c crs = TestMethodUtility.createContactRoleSelector(cr);
    crs.Opportunity__c=op.id;
    Lcrs.add(crs);
    //insert crs;
    
    Contact_Role_Selector__c crs2 = TestMethodUtility.createContactRoleSelector(cr2);
    crs2.Opportunity__c=op.id;
    Lcrs.add(crs2);
    //insert crs2; 
    insert Lcrs;
    
    
    Profile p =[Select id from profile where name='System Administrator'];
    
    User u = TestMethodUtility.createUser(p);
    insert u;

    System.RunAs(u)
     {  
        Custom_Task__c task = new Custom_Task__c();
        task.Opportunity__c = op.id;
        task.Status__c ='In Progress';
        insert task;
        
        List<Custom_Task__c> Lcus = New List<Custom_Task__c>();
        Lcus.Add(task);
        
        Group g = new Group();
        g.type='Queue';
        //g.DeveloperName='Cloud_Provisioning';
        g.name='Cloud_Provisioning';
        insert g;
        
        QueuesObject q1 = new QueueSObject(QueueID = g.id, SobjectType = 'Custom_Task__c');
        insert q1;
      
        GroupMember gm = new GroupMember();
        gm.UserOrGroupId= u.id;
        gm.Groupid = g.id;
        insert gm;
        
        Set<id> tempid = New Set<id>();  
        tempId.add(u.id);         
        FullfilmentTaskdemo f2 = new FullfilmentTaskdemo(new ApexPages.StandardController (task));
        
        FullfilmentTaskdemo.cContact wrap = new FullfilmentTaskdemo.cContact(task,tempId); 
        
        f2.getLCustTask();
        f2.GetSelectedTasks();
        f2.getSelected();
        f2.selectedTasks=Lcus;
        f2.processSelected();
       
     }
    
    
     
    }
    
}