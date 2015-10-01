/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestOpportunityWizards
    @abstract       Unit Test for all Collaborate Opportunity wizards
    @since          2011.0715
    @discussion     Test Class for Opportunity Wizards
*/

@isTest
private class TestOpportunityWizards {

    private static testMethod void collaborateOpportunityWizardRegularRSMOpp()
    {
    
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
        
                
        Product2 pr = TestMethodUtility.createProduct();
        pr.Product_Category__c = 'Web Conferencing';
        pr.Product_Sub_Category__c = 'SAAS';
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pribook= TestMethodUtility.createPricebook();
        pribook.Name='Bb Collaborate NA';
        
        insert pribook;
        
        
        Pricebook2 pri1=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri1,pr);
        insert elive1;
        
        
        
        PriceBookEntry elive = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert elive;
        
        /*
        PriceBookEntry elive = [SELECT Id FROM PriceBookEntry 
                                         WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                         AND Product2.Product_Category__c = 'Web Conferencing' 
                                         AND Product2.Product_Sub_Category__c = 'SAAS' 
                                         AND CurrencyIsoCode = 'USD'
                                         AND isActive = true
                                         LIMIT 1];
           */
            
        // Add 1 new Account from Canada
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification',CloseDate = date.today(), AccountID = account.Id);  
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Add Suite Products
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = elive.Id, Quantity = 1, UnitPrice = 4324);
        insert opportunityLineItem;
        System.assertNotEquals(opportunityLineItem.Id, null);

        
        PageReference ref = new PageReference('/apex/collabOppWizard1?id='+account.Id + '&oppid='+opportunity.Id);
        Test.setCurrentPage(ref);
        
        /* commenting out 
        CollaborateOpportunityWizardController cow = new CollaborateOpportunityWizardController();
        
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code 
        cow.getAccount();
        cow.getOpportunity();
        cow.getOpportunityLineItems();
        cow.getProducts();
        cow.getOpportunityType();
        cow.getItems();
        cow.getTypes();
        Test.StartTest();
        cow.getAccountTier();
        cow.getTiers();
        cow.getIsOnline();
        cow.getOnline();
        cow.getCurrentUserDivision();
                
        //----------------------------------
        // Testing the Opportuntiy Type and Contract combinations
        // that should not go to step 2
        //-----------------------------------       
        cow.setOpportunityType('Pilot');
        cow.getOpportunity().Contract__c = 'Annual';
        System.assertEquals(null,cow.step2());

        cow.setOpportunityType('POC');
        cow.getOpportunity().Contract__c = 'Annual';
        System.assertEquals(null,cow.step2());

        cow.setOpportunityType('StepIn');
        cow.getOpportunity().Contract__c = 'Annual';
        System.assertEquals(null,cow.step2());
        
        cow.setOpportunityType('StepIn');
        cow.getOpportunity().Contract__c = 'Multi-Year';
        cow.getOpportunity().Number_of_Years__c = '2 years';
        System.assertEquals(null,cow.step2());
        
        //----------------------------------
        // Creates a new Regular Annual Enterprise Sales Opportunity
        //-----------------------------------
        cow.setOpportunityType('Regular');
        cow.setProducts(new String[]{'Web Conferencing'});
        cow.getOpportunity().CloseDate = Date.today();
        cow.getOpportunity().Contract__c = 'Annual';
        cow.getWimbaVoiceSelected();
        cow.getELiveSelected();
        
        cow.step2();

        Decimal amount = 0;
        for(OpportunityLineItem oli:cow.getOpportunityLineItems())
        {
            amount += oli.TotalPrice;
        }
        System.assertEquals(amount.format(),cow.getOpportunitySalesValue());
        
        //----------------------------------
        // Goes back to step 1 to change products
        //-----------------------------------
        cow.step1();

        cow.setProducts(new String[]{'Enterprise IM'});
        //Go to summary screen and save
        cow.step2();
        
        //----------------------------------
        // Goes back to step 1 to change products
        //-----------------------------------
        cow.step1();

        cow.setProducts(new String[]{'Voice Authoring'});
        //Go to summary screen 
        cow.step2();
        
        //----------------------------------
        // Goes back to step 1 to change products
        //-----------------------------------
        cow.step1();

        cow.setProducts(new String[]{'Web Conferencing','Voice Authoring','Enterprise IM'});
        //Go to summary screen and save
        cow.step2();


        //----------------------------------
        // Saves Opportunity
        //-----------------------------------
        cow.save();
        Test.StopTest();
        commenting out */
    }


    private static testMethod void collaborateOpportunityWizardRegularISROpp()
    {

        // Add 1 new Account from Canada
        Account account = new Account(Name = 'Name',Industry = 'K12', Total_of_Annual_Student_FTE__c = Double.valueOf('200'), Total_of_Teachers_or_Employees__c = Double.valueOf('200'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabOppWizard1?id='+account.Id);
        Test.setCurrentPage(ref);
        
        /* commenting out 
        
        CollaborateOpportunityWizardController cow = new CollaborateOpportunityWizardController();
        cow.getCurrentUser().Division = 'Inside Sales';

        //----------------------------------
        //Create a new Regular Annual Inside Sales Opportunity
        //-----------------------------------
        cow.setOpportunityType('Regular');
        cow.setProducts(new String[]{'Web Conferencing'});
        cow.getOpportunity().CloseDate = Date.today();
        cow.getOpportunity().Contract__c = 'Annual';
        cow.getWimbaVoiceSelected();

        cow.step2();

        //----------------------------------
        // Goes back to step 1 to change products
        //-----------------------------------
        cow.step1();

        cow.setProducts(new String[]{'Enterprise IM'});
        //Go to summary screen and save
        cow.step2();
        
        //----------------------------------
        // Goes back to step 1 to change products
        //-----------------------------------
        cow.step1();

        cow.setProducts(new String[]{'Voice Authoring'});
        //Go to summary screen 
        cow.step2();
        
        //----------------------------------
        // Goes back to step 1 to change products
        //-----------------------------------
        cow.step1();

        cow.setProducts(new String[]{'Web Conferencing','Voice Authoring','Enterprise IM'});
        //Go to summary screen
        cow.step2();


        //----------------------------------
        // Saves Opportunity
        //-----------------------------------
        cow.saveAndAddProducts();
        
        commenting out */
    }

    private static testMethod void collaborateOpportunityWizardMultiYearOpp()
    {
        // Add 1 new Account  
        Account account = new Account(Name = 'Name',Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabOppWizard1?id='+account.Id);
        Test.setCurrentPage(ref);
        
        /* commenting out 
        CollaborateOpportunityWizardController cow = new CollaborateOpportunityWizardController();

        //-----------------------------------
        //Create a new Regular Multi-Year, 2 years Opportunity
        //-----------------------------------
        cow.setIsOnline(false);
        cow.setOpportunityType('Regular');
        cow.setProducts(new String[]{'Web Conferencing','Enterprise IM'});
        cow.getOpportunity().CloseDate = Date.today();
        cow.getOpportunity().Contract__c = 'Multi-Year';
        cow.getOpportunity().Number_of_Years__c = '2 years';
        
        //Go to summary screen and save
        cow.step2();
        cow.save();
        
        commenting out */
    }

    private static testMethod void collaborateOpportunityWizardStepInMOpp()
    {
        // Add 1 new Account  
        Account account = new Account(Name = 'Name',Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabOppWizard1?id='+account.Id);
        Test.setCurrentPage(ref);
        
        /* commenting out 
        CollaborateOpportunityWizardController cow = new CollaborateOpportunityWizardController();

        //-----------------------------------
        //Create a new Step-In Multi-Year, 3 years Opportunity
        //-----------------------------------
        cow.setOpportunityType('StepIn');
        cow.setProducts(new String[]{'Web Conferencing','Enterprise IM'});
        cow.getOpportunity().CloseDate = Date.today();
        cow.getOpportunity().Contract__c = 'Multi-Year';
        cow.getOpportunity().Number_of_Years__c = '3 years';
        
        //Go to summary screen and save
        cow.step2();
        cow.save();
        commenting out */
    }
    
    private static testMethod void collaborateOpportunityWizardPOCOpp()
    {
        // Add 1 new Account  
        Account account = new Account(Name = 'Name',Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabOppWizard1?id='+account.Id);
        Test.setCurrentPage(ref);
        
        /* commenting out 
        CollaborateOpportunityWizardController cow = new CollaborateOpportunityWizardController();
        
        //-----------------------------------
        //Create a new POC Opportunity
        //-----------------------------------
        cow.setOpportunityType('POC');
        cow.getOpportunity().CloseDate = Date.today();
        cow.getOpportunity().Contract__c = 'One-Time';
        
        //Go to summary screen and save
        cow.step2();
        cow.save();
        
        commenting out */
    }
    
    
    private static testMethod void collaborateOpportunityWizardBandsAndPricebooks()
    {
        // Add 1 new Account  
        Account account = new Account(Name = 'Name',Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabOppWizard1?id='+account.Id);
        Test.setCurrentPage(ref);
        /* commenting out 
        
        CollaborateOpportunityWizardController cow = new CollaborateOpportunityWizardController();
        
        //-----------------------------------
        // Test for Regular Higher Education Opp
        //-----------------------------------

        cow.getBand(cow.getOpportunity());
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 100;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'1a');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 600;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'1b');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 1500;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'1');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 3000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'2');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 5000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'3');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 10000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'4');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 20000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'5');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 40000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'6');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 60000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'7');

        cow.getAccount().Industry = 'K12';
        cow.setIsOnline(false);
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 100;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'K12 1');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 600;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'K12 2');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 1500;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'K12 3');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 3000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'K12 4');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 6000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'K12 5');
        cow.getOpportunity().Total_Number_of_Authorized_Users_License__c = 8000;
        System.assertEquals(cow.getBand(cow.getOpportunity()),'K12 6');


        //-----------------------------------
        // Test Pricebook for NA and INTL Opps
        //-----------------------------------
        cow.getPriceBook(cow.getOpportunity());
        cow.getCurrentUser().Division = 'International';
        cow.setAccountTier(1);
        cow.getPriceBook(cow.getOpportunity());
        cow.setAccountTier(2);
        cow.getPriceBook(cow.getOpportunity());
        cow.setAccountTier(3);
        cow.getPriceBook(cow.getOpportunity());
        cow.setAccountTier(4);
        cow.getPriceBook(cow.getOpportunity());
        commenting out */
    }




    private static testMethod void collaboratePartnerWizardRegularRSMOpp()
    {
    
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
        
        Product2 pr = TestMethodUtility.createProduct();
        pr.Product_Category__c = 'Web Conferencing';
        pr.Product_Sub_Category__c = 'SAAS';
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pribook= TestMethodUtility.createPricebook();
        pribook.Name='Bb Collaborate NA';
        
        insert pribook;
        
        
        Pricebook2 pri1=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri1,pr);
        insert elive1;
        
        
        
        PriceBookEntry elive = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert elive;
        
        /*
        PriceBookEntry elive = [SELECT Id FROM PriceBookEntry 
                                         WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                         AND Product2.Product_Category__c = 'Web Conferencing' 
                                         AND Product2.Product_Sub_Category__c = 'SAAS' 
                                         AND CurrencyIsoCode = 'USD'
                                         AND isActive = true
                                         LIMIT 1];

        */
        // Add 1 new Account from Canada
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification',CloseDate = date.today(), AccountID = account.Id);  
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Add Suite Products
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = elive.Id, Quantity = 1, UnitPrice = 4324);
        insert opportunityLineItem;
        System.assertNotEquals(opportunityLineItem.Id, null);

        
        PageReference ref = new PageReference('/apex/collabPartnerOppWizard?id='+account.Id + '&oppid='+opportunity.Id);
        Test.setCurrentPage(ref);
        
        /* commenting out 
        CollaboratePartnerWizardController cpw = new CollaboratePartnerWizardController();
        
        
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code 
        cpw.getAccount();
        cpw.getOpportunity();
        cpw.getOpportunityLineItems();
        cpw.getProducts();
        cpw.getOpportunityType();
        cpw.getItems();
        cpw.getTypes();
        cpw.getIsOnline();
        cpw.getOnline();
        cpw.getCurrentUserDivision();
                
        //----------------------------------
        // Testing the Opportuntiy Type and Contract combinations
        // that should not save
        //-----------------------------------       
        cpw.setOpportunityType('Pilot');
        cpw.getOpportunity().Contract__c = 'Annual';
        System.assertEquals(null,cpw.save());

        cpw.setOpportunityType('POC');
        cpw.getOpportunity().Contract__c = 'Annual';
        System.assertEquals(null,cpw.save());

        //----------------------------------
        // Creates a new Regular Annual Enterprise Sales Opportunity
        //-----------------------------------
        cpw.setOpportunityType('Regular');
        cpw.setProducts(new String[]{'Web Conferencing','Voice Authoring','Enterprise IM'});
        cpw.getOpportunity().CloseDate = Date.today();
        cpw.getOpportunity().Contract__c = 'Annual';
        cpw.getWimbaVoiceSelected();
        cpw.getELiveSelected();
        
        //Go to summary screen and save
        cpw.save();
        
        commenting out */

    }
    private static testMethod void collaboratePartnerWizardRegularISROpp()
    {
        // Add 1 new Account from Canada
        Account account = new Account(Name = 'Name',Industry = 'K12', Total_of_Annual_Student_FTE__c = Double.valueOf('200'), Total_of_Teachers_or_Employees__c = Double.valueOf('200'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabPartnerOppWizard?id='+account.Id);
        Test.setCurrentPage(ref);
        /* commenting out 
        CollaboratePartnerWizardController cpw = new CollaboratePartnerWizardController();
        cpw.getCurrentUser().Division = 'Inside Sales';

        //----------------------------------
        //Create a new Regular Annual Inside Sales Opportunity
        //-----------------------------------
        cpw.setOpportunityType('Regular');
        cpw.setProducts(new String[]{'Web Conferencing','Voice Authoring','Enterprise IM'});
        cpw.getOpportunity().CloseDate = Date.today();
        cpw.getOpportunity().Contract__c = 'Annual';
        cpw.getWimbaVoiceSelected();

        cpw.save();
        commenting out */
    }
    
    
    private static testMethod void collaboratePartnerWizardMultiYearOpp()
    {
        // Add 1 new Account  
        Account account = new Account(Name = 'Name',Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabPartnerOppWizard?id='+account.Id);
        Test.setCurrentPage(ref);
        /* commenting out 
        CollaboratePartnerWizardController cpw = new CollaboratePartnerWizardController();

        //-----------------------------------
        //Create a new Regular Multi-Year, 2 years Opportunity
        //-----------------------------------
        cpw.setIsOnline(false);
        cpw.setOpportunityType('Regular');
        cpw.setProducts(new String[]{'Web Conferencing','Enterprise IM'});
        cpw.getOpportunity().CloseDate = Date.today();
        cpw.getOpportunity().Contract__c = 'Multi-Year';
        cpw.getOpportunity().Number_of_Years__c = '2 years';
        
        cpw.save();
        commenting out */
    }
    
    
    private static testMethod void collaboratePartnerWizardBandsAndPricebooks()
    {
        // Add 1 new Account  
        Account account = new Account(Name = 'Name',Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        PageReference ref = new PageReference('/apex/collabPartnerOppWizard?id='+account.Id);
        Test.setCurrentPage(ref);
        /* commenting out
        CollaboratePartnerWizardController cpw = new CollaboratePartnerWizardController();
        
        //-----------------------------------
        // Test for Regular Higher Education Opp
        //-----------------------------------
        cpw.getBand(cpw.getOpportunity());
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 100;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'1a');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 600;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'1b');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 1500;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'1');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 3000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'2');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 5000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'3');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 10000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'4');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 20000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'5');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 40000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'6');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 60000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'7');

        cpw.getAccount().Industry = 'K12';
        cpw.setIsOnline(false);
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 100;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'K12 1');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 600;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'K12 2');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 1500;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'K12 3');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 3000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'K12 4');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 6000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'K12 5');
        cpw.getOpportunity().Total_Number_of_Authorized_Users_License__c = 8000;
        System.assertEquals(cpw.getBand(cpw.getOpportunity()),'K12 6');


        //-----------------------------------
        // Test Pricebook for NA and INTL Opps
        //-----------------------------------
        cpw.getPriceBook(cpw.getOpportunity());
        cpw.getCurrentUser().Division = 'International';
        cpw.getPriceBook(cpw.getOpportunity());
        commenting out */
    }
    
}