@isTest(SeeAllData=True)
public class FullfillmentReviewTest {

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
    
    //Standard pricebook
    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
    Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
    
    PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
    pes.UseStandardPrice = false;
    insert pes;
    
    PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
    pe.UseStandardPrice = false;
    insert pe;
   
    Opportunity op =TestMethodUtility.createOpportunity(acc,pb);
    insert op;
       
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
       
       Attachment attach=new Attachment();    
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=op.id;
       insert attach;
       
       List<Attachment> attachments=[select id, name from Attachment where parent.id=:op.id];
       System.assertEquals(1, attachments.size());

    ApexPages.currentPage().getParameters().put('id',op.id);
    
    FullfillmentReview ctr = new FullfillmentReview(new ApexPages.StandardController (op));
    ctr.Save();
    ctr.uploadFile();
    ctr.loadAttachments();
    ctr.SendMail();
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
       
    /*OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId = pe2.Id);
    oli.OpportunityId=op2.id;
    oli.Quantity=1; 
    insert oli;
    
    Contact_Role__c cr = TestMethodUtility.createContactRole(acc2);
    cr.Contact__c=c.id;
    cr.Role__c='ANALYTICS - Primary Sales Contact';
    cr.Role__c='ANALYTICS - Primary Sales Technical Contact';
    insert cr;
    
    Contact_Role_Selector__c crs = TestMethodUtility.createContactRoleSelector(cr);
    crs.Opportunity__c=op.id;
    insert crs; */
    ApexPages.currentPage().getParameters().put('id',op2.id);
    
    FullfillmentReview ctr = new FullfillmentReview(new ApexPages.StandardController (op2));
    ctr.Save();
    ctr.uploadFile();
    ctr.loadAttachments();
    ctr.SendMail();
    }
    
    static testMethod void myUnitTest3() {
    
    Account acc2 = TestMethodUtility.createAccount();
    insert acc2;
    
    Pricebook2 pb2 = [select Id from pricebook2 where Name='CPQ' limit 1];
    
    Opportunity op3 =TestMethodUtility.createOpportunity(acc2,pb2);
    insert op3;
    
    FullfillmentReview ctr2 = new FullfillmentReview(new ApexPages.StandardController (op3));
    } 
}