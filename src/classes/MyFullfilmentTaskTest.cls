@isTest(SeeAllData=True)
public class MyFullfilmentTaskTest{
    static testMethod void myUnitTest() {

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
    
    User u = TestMethodUtility.createUser(p);
    insert u;

       
    Custom_Task__c task = new Custom_Task__c();
    task.Opportunity__c = op.id;
    insert task;
        
    //ApexPages.currentPage().getParameters().put('id',task.id);
              
    MyFullfilmentTask f1 = new MyFullfilmentTask(new ApexPages.StandardController (task));
    f1.ViewData();
    f1.getLCustTask();
    String sortExpression ='';
    String sortExp='name';
    String sortDirection='DESC';
    f1.sortExpression=sortExp;
    f1.setSortDirection('ASC');
    f1.getSortDirection();
    
    f1.sortExpression='';
    f1.getSortDirection();
    
    }
    }