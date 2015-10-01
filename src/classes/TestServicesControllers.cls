/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestOpportunityWizards
    @abstract       Unit Test for Opportunity product conversion to Services Projects and Services Engagements
    @since          2011.0715
    @discussion     Test Class for Services conversion wizard
*/

@isTest
private class TestServicesControllers{


    private static testMethod void convertToServicesTest()
    {
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'convertToServicesTest@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id, Primary_Contact__c = contact.Id);
        insert opportunity;
        
        Contact_Role__c conrole =TestMethodUtility.createContactRole(account);
        conrole.Role__c='COLLABORATE - Primary Sales Technical Contact';
        Insert conrole;
        
        Contact_Role_Selector__c  Conrolesel =TestMethodUtility.createContactRoleSelector(conrole);
        Conrolesel.Opportunity__c=opportunity.id;
        Insert  Conrolesel;
        
        System.assertNotEquals(opportunity.Id, null);

        PageReference ref = new PageReference('/apex/convertToServices?id='+opportunity.Id);
        Test.setCurrentPage(ref);
        
        ConvertToServicesController ctsc = new ConvertToServicesController();
        ctsc.getOpportunity();
        ctsc.getServicesProject();        
        System.assertEquals(0,ctsc.getServicesEngagements().size());
        
        Product2 pr = TestMethodUtility.createProduct();
        pr.Product_Category__c = 'Services';
        pr.Product_Sub_Category__c = 'Implementation Service';
        pr.External_Long_Description__c = 'All Module';
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pribook= TestMethodUtility.createPricebook();
        pribook.Name='Bb Collaborate NA';
        
        insert pribook;
        
        
        Pricebook2 pri=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri,pr);
        insert elive1;
        
        PriceBookEntry implementationService = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert implementationService ;
        
        Product2 pr1 = TestMethodUtility.createProduct();
        pr1.Product_Category__c = 'Services';
        pr1.Product_Sub_Category__c = 'Learning Services';
        pr1.External_Long_Description__c = 'All Module';
        pr1.Isactive=True;
        insert pr1;
        
        /*Pricebook2 pribook1= TestMethodUtility.createPricebook();
        pribook1.Name='Bb Collaborate NA';
        insert pribook1;*/
        
        Pricebook2 pri1=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive2 = TestMethodUtility.createPriceBookEntry(pri1,pr1);
        insert elive2;
        
        PriceBookEntry learningService = TestMethodUtility.createPriceBookEntry(pribook,pr1);
        insert learningService ;
        
       /*
        PriceBookEntry implementationService = [SELECT Id FROM PriceBookEntry 
                                     WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                     AND Product2.Product_Category__c = 'Services' 
                                     AND Product2.Product_Sub_Category__c = 'Implementation Service' 
                                     AND CurrencyIsoCode = 'USD'
                                     AND isActive = true
                                     LIMIT 1];
        
            PriceBookEntry learningService = [SELECT Id FROM PriceBookEntry 
                                     WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                     AND Product2.Product_Category__c = 'Services' 
                                     AND Product2.Product_Sub_Category__c = 'Learning Services' 
                                     AND CurrencyIsoCode = 'USD'
                                     AND isActive = true
                                     LIMIT 1];
                                     */

        //Add Services Products
        OpportunityLineItem implementationServiceLineItem = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = implementationService.Id, Quantity = 1, UnitPrice = 4324);
        insert implementationServiceLineItem;
        System.assertNotEquals(implementationServiceLineItem.Id, null);
        OpportunityLineItem learningServiceLineItem = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = learningService.Id, Quantity = 1, UnitPrice = 4324);
        insert learningServiceLineItem;
        System.assertNotEquals(learningServiceLineItem.Id, null);
        
        ctsc = new ConvertToServicesController();

        ctsc.getServicesProject().Start_Date__c = Date.today();
        ctsc.getServicesProject().End_Date__c = Date.today();
        for (Services_Engagement__c se: ctsc.getServicesEngagements())
        {
            se.Service_Sub_Type__c = '1 day';
            se.Status__c = 'Scheduled';
            se.Primary_Contact__c = contact.Id;
        }
        ctsc.save();
    }


    private static testMethod void splitServicesEngagementTest()
    {
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'convertToServicesTest@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id, Primary_Contact__c = contact.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Create TEST Services Project        
        Services_Project__c sp = new Services_Project__c(Account__c = account.Id, Opportunity__c = opportunity.Id, Start_Date__c = Date.today().addYears(12), End_Date__c = Date.today().addYears(-12));
        insert sp;
        System.assertNotEquals(sp.Id, null);
        
        //Create TEST Services Engagements        
        Services_Engagement__c se = new Services_Engagement__c(Services_Project__c = sp.Id, Product__c = 'Web Conferencing', Service_Type__c = 'Implementation Service', Service_Sub_Type__c = '1 day', Primary_Contact__c = contact.Id, Account__c = account.Id, Opportunity__c = opportunity.Id, Start_Date__c = Date.today(), End_Date__c = Date.today(), Dollar_Value__c = 500);
        insert se;
        System.assertNotEquals(se.Id, null);  


        PageReference ref = new PageReference('/apex/splitServicesEngagement?id='+se.Id);
        Test.setCurrentPage(ref);
        
        splitServicesEngagementController ssec = new splitServicesEngagementController();
        System.assertEquals(se.Id,ssec.getOldServicesEngagement().Id);
        System.assertEquals(1,ssec.getNewServicesEngagements().size());
        ssec.addServicesEngagement();
        System.assertEquals(2,ssec.getNewServicesEngagements().size());
        ssec.removeServicesEngagement();
        System.assertEquals(1,ssec.getNewServicesEngagements().size());
        ssec.cancel();
        
        for (Services_Engagement__c tmp: ssec.getNewServicesEngagements())
        {
            tmp.Service_Type__c = 'Implementation Service';
            tmp.Service_Sub_Type__c = '1 day';
            tmp.Product__c = 'Web Conferencing';
            tmp.Status__c = 'Unscheduled';
            tmp.Primary_Contact__c = contact.Id;
            tmp.Dollar_Value__c = 4;
        }
        System.assertEquals(null,ssec.save());
        
        
        for (Services_Engagement__c tmp: ssec.getNewServicesEngagements())
        {
            tmp.Service_Type__c = 'Implementation Service';
            tmp.Service_Sub_Type__c = '1 day';
            tmp.Product__c = 'Web Conferencing';
            tmp.Status__c = 'Unscheduled';
            tmp.Primary_Contact__c = contact.Id;
            tmp.Dollar_Value__c = 0;
        }
        System.assertNotEquals(null,ssec.save());
    }


    private static testMethod void servicesForecastTest()
    {
        // Below And Part is commented by Nikhil. Since these role has been deleted in production
        User director = [select Id, Name from User where isActive = True /* AND UserRole.Name IN ('Collab Sr.Director,Professional Services') */ Limit 1];
        String thisMonth = DateTime.now().format('MMMM');

        PageReference ref = new PageReference('/apex/servicesForecast?userid='+director.Id+'&period='+thisMonth);
        Test.setCurrentPage(ref);

        ServicesForecastController sfc = new ServicesForecastController();
        sfc.getServicesProjects();
        sfc.getServicesEngagements();
        sfc.displayServices();
        sfc.displayServicesEngagements();
        
        for(ServicesForecastPeriod sfp: sfc.getServicesForecastPeriods())
        {
            sfp.getStartDate();
            for(ServicesForecastPeriod.ServicesForecastMonth sfm: sfp.getServicesForecastMonths())
            {
                sfm.getInProgressServicesProjects();
                sfm.getDollarValue();
            }
        }
    }
 }