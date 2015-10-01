/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestAddOpportunityLineItemsController
    @abstract       Unit Test add Opportunity Line Items wizard
    @since          2011.0715
    @discussion     Test Class for Opportunity Line Items wizard
*/

@isTest
private class TestAddOpportunityLineItemsController {

    private static testMethod void testAddOpportunityLineItemsControllerTest()
    {

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        AddOpportunityLineItemsController aolic = new AddOpportunityLineItemsController(sc);
        
        //Adds the Pricebook to the Opportuntiy
       //opportunity.Pricebook2Id = [SELECT Id FROM Pricebook2 WHERE Name = 'Bb Collaborate NA' AND isActive = true LIMIT 1].Id;
      
        
        pricebook2 pribook = TestMethodUtility.CreatePricebook();
        Insert Pribook;
        opportunity.Pricebook2Id =Pribook.id; 
        
        
        update opportunity;
        sc = new ApexPages.StandardController(opportunity);
        aolic = new AddOpportunityLineItemsController(sc);


        aolic.getOpportunity();
        aolic.choosePricebook();
        
        //search product by name
        aolic.searchText = 'Web Conferencing';
        aolic.search();
        for(AddOpportunityLineItemsController.productWrapper searchResult:aolic.searchResults)
        {
            searchResult.setProduct(searchResult.getProduct());
            searchResult.getSelected();
            searchResult.setSelected(true);
        }
        aolic.next();
        aolic.back();
        aolic.cancel();
        aolic.saveAndAddMore();

        //Filter by Product Product_Category__c, SubCategory and Band
        aolic.getProductCategoryList();
        aolic.setProductCategories(new String[]{'Wimba Pronto'});
        aolic.getProductCategories();
        aolic.getProductSubCategoryList();
        aolic.setProductSubCategories(new String[]{'SAAS'});
        aolic.getProductSubCategories();
        aolic.getProductBands();
        aolic.productBand= '1';
        aolic.filter();
        for(AddOpportunityLineItemsController.productWrapper searchResult:aolic.searchResults)
        {
            searchResult.setProduct(searchResult.getProduct());
            searchResult.getSelected();
            searchResult.setSelected(true);
        }
        aolic.next();
        for(OpportunityLineItem lineItem:aolic.lineItems)
        {
            lineItem.Quantity = 1;
        }
        aolic.save();
    }
}