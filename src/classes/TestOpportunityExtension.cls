/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestOpportunityExtension
    @abstract       Test class for TestOpportunityExtension.
    @since          2011.0715
    @discussion     Test class for TestOpportunityExtension.
*/

@isTest
private class TestOpportunityExtension{

    private static testMethod void testOpportunityExtension()
    {
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Test of the Account logic
        Account account = new Account(Name = 'Name', Industry = 'Higher Education', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'),BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211',BillingCountry = 'USA');
        insert account;            
        System.assertNotEquals(account.Id, null);

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'testOpportunityExtension@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);
        
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today(), License_End_Date__c = date.today(), LeadSource='Behind Blackboard Online Form', Primary_Contact__c = contact.Id);
        opportunity.AccountId = account.Id;
        insert opportunity;            
        System.assertNotEquals(opportunity.Id, null);            
                
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        OpportunityExtension oe = new OpportunityExtension(sc);
        
        oe.getEditMode();
        oe.edit();
        oe.save();        
    }
 }