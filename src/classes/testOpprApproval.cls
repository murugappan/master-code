/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testOpprApproval {

    static testMethod void FillProductList() 
    {
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'convertToServicesTest@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);

         Pricebook2 pribook= TestMethodUtility.createPricebook();
        //pribook.Name='Bb Collaborate NA';
        
        insert pribook;
        
        //Create TEST Opportunity
        Opportunity oppr = new Opportunity(Name = 'Apex Test', Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id, Primary_Contact__c = contact.Id);
        oppr.Pricebook2Id = pribook.Id;
        
        
        Product2 pr = TestMethodUtility.createProduct();
        /*pr.Product_Category__c = 'Services';
        pr.Product_Sub_Category__c = 'Implementation Service';*/
        
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pri=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri,pr);
        insert elive1;
        
        PriceBookEntry implementationService = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert implementationService ;
       /* String accountId = '0017000000SeU0BAAV';        // Rowan University
        String contactId = '0037000000bnL3ZAAU';        // Dennis Blow
        string ownerId = '00570000001ED9MAAW';          // castiron
        string Pricebook2Id = '01s700000006lK7AAI';     // NA Higher Ed 2009        
        string PricebookEntryId = '01u70000002RT7dAAG'; // AS-LS-HENA01
        

        // create an opportunity
        Opportunity oppr = new Opportunity();
        oppr.Pricebook2Id = Pricebook2Id;
        oppr.AccountId = accountId;
        oppr.Name = 'Bb Test Opp';
        oppr.OwnerId =  ownerId;  
        oppr.Type = 'New Business';
        oppr.StageName = '(D) Power Sponsor Qualification';
        oppr.CloseDate = system.Today();
        oppr.Record_Type_Locked__c = false;
        oppr.Closed_in_Psft__C = false;    */ 
        
        Test.StartTest();
        insert oppr;
        Test.stopTest();
        
        OpportunityLineItem line = new OpportunityLineItem(opportunityId = oppr.id, PricebookEntryId = implementationService.Id, Quantity = 1, UnitPrice = 1000);
        insert Line;
        // create an Opportunity Product
        /*OpportunityLineItem line = new OpportunityLineItem();           
        line.OpportunityId = oppr.Id;
        line.PricebookEntryId = PricebookEntryId;
        line.UnitPrice = 1000;  
        line.Quantity = 1;      
        insert line;   
         */
               
        // create an approval object       
        Bb_Approvals__c appr = new Bb_Approvals__c ();
        appr.Name = 'Test';      
        appr.Opportunity__c = oppr.Id;
        appr.Approval_Comments__c = 'Commments';       
        appr.Managed_Hosting__c = false;
        appr.Vertical_Leadership__c = false;
        appr.Training__c = false;
        appr.Services__c = false;
        appr.RVP__c = false;
        appr.Presidium__c = false;    
        insert appr;
        
        appr.Approval_Status__c = 'Pending';
        appr.Approval_Comments__c = 'Commment Again';    
        update appr;    
    }
    
    
    static testMethod void FillApproverList() 
    {
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'convertToServicesTest@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);
        
        Pricebook2 pribook= TestMethodUtility.createPricebook();
        //pribook.Name='Bb Collaborate NA';
        insert pribook;

        //Create TEST Opportunity
        Opportunity oppr = new Opportunity(Name = 'Apex Test', Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id, Primary_Contact__c = contact.Id);
        oppr.Pricebook2Id = pribook.Id;
        
        
        Product2 pr = TestMethodUtility.createProduct();
        /*pr.Product_Category__c = 'Services';
        pr.Product_Sub_Category__c = 'Implementation Service';
        pr.External_Long_Description__c = 'All Module';*/
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pri=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri,pr);
        insert elive1;
        
        /*PriceBookEntry implementationService = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert implementationService ;
        
        String accountId = '0017000000SeU0BAAV';        // Rowan University
        String contactId = '0037000000bnL3ZAAU';        // Dennis Blow
        string ownerId = '00570000001ED9MAAW';          // castiron
        string Pricebook2Id = '01s700000006lK7AAI';     // NA Higher Ed 2009        
        string PricebookEntryId = '01u70000002RT7dAAG'; // AS-LS-HENA01
        
        // create an opportunity
        Opportunity oppr = new Opportunity();
        oppr.Pricebook2Id = Pricebook2Id;
        oppr.AccountId = accountId;
        oppr.Name = 'Bb Test Opp';
        oppr.OwnerId =  ownerId;  
        oppr.Type = 'New Business';
        oppr.StageName = '(D) Power Sponsor Qualification';
        oppr.CloseDate = system.Today();
        oppr.Record_Type_Locked__c = false;
        oppr.Closed_in_Psft__C = false; 
        */    
        
        Test.StartTest();
        insert oppr;
        Test.stopTest();        
               
        // create an approval object       
        Bb_Approvals__c appr = new Bb_Approvals__c ();
        appr.Name = 'Test';      
        appr.Opportunity__c = oppr.Id;
        appr.Approval_Comments__c = 'Commments';       
        appr.Managed_Hosting__c = true;
        appr.Vertical_Leadership__c = true;
        appr.Training__c = true;
        appr.Services__c = true;
        appr.RVP__c = true;
        appr.Presidium__c = true;    
        insert appr;            
    }
  
}