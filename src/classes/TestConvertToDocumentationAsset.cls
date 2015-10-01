/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestConvertToDocumentationAsset
    @abstract       Unit Test for Opportunity product conversion to Documentation Assets
    @since          2011.0715
    @discussion     Test Class for Documentation Assets conversion wizard
*/
@isTest
private class TestConvertToDocumentationAsset{

    private static testMethod void convertToDocumentationAssetTest()
    {

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'convertToDocumentationAssetTest@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);
        
        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
        
        PageReference ref = new PageReference('/apex/convertToDocumentationAsset?id='+opportunity.Id);
        Test.setCurrentPage(ref);
        
        convertToDocumentationAssetController ctdac = new convertToDocumentationAssetController();
        System.assertEquals(ctdac.getOpportunity().Id, opportunity.Id);
        System.assertEquals(null, ctdac.getDocumentationAsset());
        System.assertEquals(null, ctdac.save());
        
        //Add Line Items to the Opportunity
        List<OpportunityLineItem> opportunityItemList = new List<OpportunityLineItem >();                  
        
        PriceBookEntry materialsLicense = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Services' 
                                    AND Product2.Product_Sub_Category__c = 'Materials' 
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];

        OpportunityLineItem item1 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = materialsLicense.Id, Quantity = 1, UnitPrice = 4324);
        opportunityItemList.add(item1);

        insert opportunityItemList;
        System.assertNotEquals(item1.Id, null);
        
        ctdac = new convertToDocumentationAssetController();
        System.assertNotEquals(null, ctdac.save());
    }  
}