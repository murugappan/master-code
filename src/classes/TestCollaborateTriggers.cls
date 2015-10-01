/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestTriggers
    @abstract       Unit Test for all Collaborate triggers
    @since          2011.0715
    @discussion     Test Class for Collaborate triggers
*/

@isTest
private class TestCollaborateTriggers  {

    private static testMethod void changeOpportunityTypeForCollaborateResellersTest(){

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
        
         //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

         //Create TEST Account
        Account partnerAccount = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert partnerAccount;            
        System.assertNotEquals(partnerAccount.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
    
        //Add Partner
        account.Reseller__c = partnerAccount.Id;
        update account;
        
        opportunity.Channel_Partner__c = partnerAccount.Id;
        update opportunity;

        Id resellerRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Reseller Opportunity'].Id;
        opportunity = [SELECT RecordTypeId FROM Opportunity WHERE Id = :opportunity.Id];
        //System.assertEquals(opportunity.RecordTypeId, resellerRecordTypeId);
    }

    private static testMethod void collaborateSalesTeamAssignmentNotificationTest(){
        
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Add Sales Team Member
        OpportunityTeamMember ics = new OpportunityTeamMember(opportunityId = opportunity.id, TeamMemberRole = 'Collaborate ICS');  
        ics.UserId = [SELECT Id FROM User where isActive = true limit 1].Id;
        insert ics;
        System.assertNotEquals(ics.Id, null);

        //Checks Sales Team Assigned to trigger notification.
        opportunity.Sales_Team_assigned__c = true;
        update opportunity;
    }
    

    private static testMethod void createCollaboratePilotConversionOpportunityTest(){

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
        /*
        PriceBookEntry eLive = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Web Conferencing' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS' 
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];
                                    */
        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'Pilot', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
        
        Product2 pr = TestMethodUtility.createProduct();
        pr.Product_Category__c = 'Web Conferencing';
        pr.Product_Sub_Category__c = 'SAAS'; 
        
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pribook= TestMethodUtility.createPricebook();
        pribook.Name='Bb Collaborate NA';
        
        insert pribook;
        
        
        Pricebook2 pri=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri,pr);
        insert elive1;
        
        PriceBookEntry eLive = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert eLive ;
        Test.StartTest();
        OpportunityLineItem item = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = eLive.Id, Quantity = 1, UnitPrice = 4324);
        insert item;

        opportunity.StageName = '(W) Won';
       // update opportunity;
        Test.StopTest();
       
    }


    private static testMethod void updateServicesMasterObjectDatesTest(){

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Create TEST Services Project        
        Services_Project__c sp = new Services_Project__c(Account__c = account.Id, Opportunity__c = opportunity.Id, Start_Date__c = Date.today().addYears(12), End_Date__c = Date.today().addYears(-12));
        insert sp;
        System.assertNotEquals(sp.Id, null);
        
        //Create TEST Services Engagements        
        Services_Engagement__c se = new Services_Engagement__c(Services_Project__c = sp.Id, Service_Type__c = 'Online Workshop', Service_Sub_Type__c = '1 day', Account__c = account.Id, Opportunity__c = opportunity.Id, Start_Date__c = Date.today(), End_Date__c = Date.today());
        se.Primary_Contact__c = [SELECT Id FROM Contact LIMIT 1].Id;
        insert se;
        System.assertNotEquals(se.Id, null);
    }

// Commenting Collaborate products as no need of..
/*
    private static testMethod void setCollaborateOpportunityProductsTest(){
        
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        PriceBookEntry classroom = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Wimba Classroom' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS' 
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];
        PriceBookEntry elive = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Web Conferencing' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS' 
                                    AND Product2.External_Long_Description__c LIKE '%)'
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];

        PriceBookEntry cohort = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Web Conferencing' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS'
                                    AND Product2.External_Long_Description__c LIKE '%Evaluation License'
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];

        PriceBookEntry voice = [SELECT Id FROM PriceBookEntry 
                                WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                AND Product2.Product_Category__c = 'Voice Authoring' 
                                AND Product2.Product_Sub_Category__c = 'SAAS' 
                                AND CurrencyIsoCode = 'USD'
                                AND isActive = true
                                LIMIT 1];
        PriceBookEntry create = [SELECT Id FROM PriceBookEntry 
                                 WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                 AND Product2.Product_Category__c = 'Wimba Create' 
                                 AND Product2.Product_Sub_Category__c = 'License' 
                                 AND CurrencyIsoCode = 'USD'
                                 AND isActive = true
                                 LIMIT 1];
        PriceBookEntry pronto = [SELECT Id FROM PriceBookEntry 
                                 WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                 AND Product2.Product_Category__c = 'Enterprise IM' 
                                 AND Product2.Product_Sub_Category__c = 'SAAS' 
                                 AND CurrencyIsoCode = 'USD' 
                                 AND isActive = true
                                 LIMIT 1];
        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
        
        //Add Suite Products
        List<OpportunityLineItem> opportunityItemList = new List<OpportunityLineItem >();
        OpportunityLineItem item1 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = classroom.Id, Quantity = 1, UnitPrice = 4324, Product_Upgrade__c = True);
        opportunityItemList.add(item1);
        OpportunityLineItem item2 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = elive.Id, Quantity = 1, UnitPrice = 4324, Product_Upgrade__c = True);
        opportunityItemList.add(item2);
        OpportunityLineItem item3 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = voice.Id, Quantity = 1, UnitPrice = 4324, Product_Upgrade__c = True);
        opportunityItemList.add(item3);
        OpportunityLineItem item4 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = create.Id, Quantity = 1, UnitPrice = 4324, Product_Upgrade__c = True);
        opportunityItemList.add(item4);
        OpportunityLineItem item5 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = pronto.Id, Quantity = 1, UnitPrice = 4324, Product_Upgrade__c = True);
        opportunityItemList.add(item5);
        OpportunityLineItem item6 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = cohort.Id, Quantity = 1, UnitPrice = 4324, Product_Upgrade__c = True);
        opportunityItemList.add(item6);
        insert opportunityItemList;
        
        System.assertNotEquals(item1.Id, null);
        System.assertNotEquals(item2.Id, null);
        System.assertNotEquals(item3.Id, null);
        System.assertNotEquals(item4.Id, null);
        System.assertNotEquals(item5.Id, null);
        System.assertNotEquals(item6.Id, null);
        
        update opportunity;
        
        opportunity = [SELECT Opportunity_Products__c,  Opportunity_Product_Changes__c FROM Opportunity WHERE Id = :opportunity.Id];
        */
       //System.assertNotEquals(opportunity.Opportunity_Products__c,null);
       /* System.assert(opportunity.Opportunity_Products__c.contains('Classroom'));
        System.assert(opportunity.Opportunity_Products__c.contains('Voice'));
        System.assert(opportunity.Opportunity_Products__c.contains('eLive!'));
        System.assert(opportunity.Opportunity_Products__c.contains('Cohort'));
        System.assert(opportunity.Opportunity_Products__c.contains('Pronto'));
        System.assert(opportunity.Opportunity_Products__c.contains('Create'));*/

        //System.assertNotEquals(opportunity.Opportunity_Product_Changes__c,null);
        //System.assertEquals(opportunity.Opportunity_Product_Changes__c, 'Upgrade Only');
   /*     
    }
    
    private static testMethod void setCollaborateOpportunityProductTypesTest(){
        
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        PriceBookEntry hostingProduct = [SELECT Id FROM PriceBookEntry 
                                         WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                         AND Product2.Product_Sub_Category__c = 'SAAS' 
                                         AND CurrencyIsoCode = 'USD'
                                         AND isActive = true
                                         LIMIT 1];
        PriceBookEntry servicesProduct = [SELECT Id FROM PriceBookEntry 
                                          WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                          AND Product2.Product_Category__c = 'Services' 
                                          AND Product2.Product_Sub_Category__c != 'Telephone' 
                                          AND Product2.Product_Sub_Category__c != 'Materials' 
                                          AND CurrencyIsoCode = 'USD' 
                                          AND isActive = true
                                          LIMIT 1];
        PriceBookEntry materialsProduct = [SELECT Id FROM PriceBookEntry 
                                       WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                       AND Product2.Product_Category__c = 'Services' 
                                       AND Product2.Product_Sub_Category__c = 'Materials' 
                                       AND CurrencyIsoCode = 'USD' 
                                       AND isActive = true
                                       LIMIT 1];        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
        
        //Add Suite Products
        List<OpportunityLineItem> opportunityItemList = new List<OpportunityLineItem >();
        OpportunityLineItem item1 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = hostingProduct.Id, Quantity = 1, UnitPrice = 4324);
        opportunityItemList.add(item1);
        OpportunityLineItem item2 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = servicesProduct.Id, Quantity = 1, UnitPrice = 4324);
        opportunityItemList.add(item2);
        OpportunityLineItem item3 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = materialsProduct.Id, Quantity = 1, UnitPrice = 4324);
        opportunityItemList.add(item3);
        insert opportunityItemList;
        
        System.assertNotEquals(item1.Id, null);
        System.assertNotEquals(item2.Id, null);
        System.assertNotEquals(item3.Id, null);
        
        update opportunity;
        opportunity = [SELECT Opportunity_Product_Types__c FROM Opportunity WHERE Id = :opportunity.Id];
        //System.assertNotEquals(opportunity.Opportunity_Product_Types__c,null);
        //System.assert(opportunity.Opportunity_Product_Types__c.contains('Hosting'));
        //System.assert(opportunity.Opportunity_Product_Types__c.contains('Services'));
        //System.assert(opportunity.Opportunity_Product_Types__c.contains('Materials'));
    }
  */      
   /* 
    private static testMethod void createTaskForServicesEngagementStaffTest(){

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);
        
        Services_Project__c sp = new Services_Project__c(Account__c = account.Id, Opportunity__c = opportunity.Id);
        insert sp;
        
        //Create TEST Services Engagements        
        Services_Engagement__c se = new Services_Engagement__c();
        se.Services_Project__c = sp.Id;
        se.Service_Type__c = 'Online Workshop';
        se.Service_Sub_Type__c = '1 day';
        se.Primary_Contact__c = [SELECT Id FROM Contact LIMIT 1].Id;
        se.Account__c = account.Id;
        se.Opportunity__c = opportunity.Id;
        
        insert se;
        System.assertNotEquals(se.Id, null);
        
        se.Trainer__c =  [SELECT Id FROM User WHERE isActive = True LIMIT 1].Id;
        update se;
        
        Task t1 = [select id, WhatId, Subject, ActivityDate, OwnerId, Type from Task where OwnerId = :se.Trainer__c and WhatId = :se.id limit 1];
        System.assertNotEquals(t1, null);
        System.assertEquals(t1.Subject,'You have been assigned to a Services Engagement');
        System.assertEquals(t1.Type,'Other');
        
        se.Trainer__c = [SELECT Id FROM User WHERE isActive = True AND Id != :se.Trainer__c LIMIT 1].Id;
        update se;
        
        Task t2 = [select id, WhatId, Subject, ActivityDate, OwnerId, Type from Task where OwnerId = :se.Trainer__c and WhatId = :se.id limit 1];
        System.assertNotEquals(t2, null);
        System.assertEquals(t2.Subject,'You have been assigned to a Services Engagement');
        System.assertEquals(t2.Type,'Other');
    }
  */  
  // Below Method has been commented because it has already BbopportunityTriggerHandler   
  /*  private static testMethod void updateCollaborateCohortStatusOnAccountTest(){

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        PriceBookEntry cohort = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Web Conferencing' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS'
                                    AND Product2.External_Long_Description__c LIKE '%Evaluation License'
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];
                                            
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'Pilot', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        OpportunityLineItem item = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = cohort.Id, Quantity = 1, UnitPrice = 4324);
        insert item;

        opportunity.StageName = '(W) Won';
        update opportunity;
        
        account = [SELECT Id, Bb_Collaborate_11_transition_stage__c FROM Account WHERE Id = :account.Id];
      //System.assertEquals('Cohort', account.Bb_Collaborate_11_transition_stage__c);
    }
 */
 /*
    private static testMethod void setCollaborateOpportunityContactsTest(){
        
        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'Pilot', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'setCollaborateOpportunityContactsTest@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);
        
        
        //Insert 2 Contact Roles to the Opportunity
        OpportunityContactRole ocr1 = new OpportunityContactRole(OpportunityId = opportunity.Id, ContactId = contact.Id, Role = 'Sponsor');
        insert ocr1;
        System.assertNotEquals(ocr1.Id, null);
        
        OpportunityContactRole ocr2 = new OpportunityContactRole(OpportunityId = opportunity.Id, ContactId = contact.Id, Role = 'Power Sponsor');
        insert ocr2;
        System.assertNotEquals(ocr2.Id, null);
        
        //Update the Opportunity to run the trigger
        opportunity.Name = 'Apex Test updated';
        update opportunity;
        
        opportunity = [SELECT Id, Contact_List__c FROM Opportunity WHERE Id = :opportunity.Id];    
        //System.assertNotEquals(opportunity.Contact_List__c, null);
        //System.assert(opportunity.Contact_List__c.contains('Sponsor'));
        //System.assert(opportunity.Contact_List__c.contains('Power Sponsor'));
    }
   */ 
   /*
    private static testMethod void closeCollaborateFinanceTaskWhenInvoicedTest(){

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        PriceBookEntry eLive = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Web Conferencing' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS' 
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    LIMIT 1];
        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        OpportunityLineItem item = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = eLive.Id, Quantity = 1, UnitPrice = 4324);
        insert item;

        opportunity.StageName = '(W) Won';
        //update opportunity;
        
        Task SampleTask = new Task(WhatId=opportunity.Id,Status='In Progress',Priority='Normal',Subject='This is Sample Task we created for Test class');
        insert  SampleTask;
        Task financeInvoiceTask = [SELECT Id, Status, IsClosed FROM Task WHERE Subject = 'Collab Opp Ready to be Invoiced' AND WhatId = : opportunity.Id LIMIT 1];
        System.assertNotEquals(financeInvoiceTask.Id, null);
        System.assertEquals(financeInvoiceTask.isClosed, False);

        opportunity.Invoice_Number__c = '000000';
      //  update opportunity;
        
       // financeInvoiceTask = [SELECT Id, Status, IsClosed FROM Task WHERE Subject = 'Collab Opp Ready to be Invoiced' AND WhatId = : opportunity.Id LIMIT 1];
       // System.assertEquals(financeInvoiceTask.IsClosed, True);
      
    }
   */
   /* 
    Private Static Testmethod void TypeOpportunityTest()
     {
      
      ID bbCollabRecordTypeId =[Select id from RecordType where Name ='Collaborate Unlocked Opportunity'].id; 
        
        //Profile
        Profile p =[Select id from Profile where Name='System Administrator'];
        List<User> Luser = new List<User>();
        
        User u1 =TestMethodUtility.createUser(p);
        u1.SalesReportingGroup__c='Learn - NAHE';
        
        User u2 =TestMethodUtility.createUser(p);
        u2.SalesReportingGroup__c='Connect';
        
        User u3 =TestMethodUtility.createUser(p);
        u3.SalesReportingGroup__c='Transact';
        
        User u4 =TestMethodUtility.createUser(p);
        u4.SalesReportingGroup__c='Mobile';
        
        User u5 =TestMethodUtility.createUser(p);
        u5.SalesReportingGroup__c='Analytics';
        
        User u6 =TestMethodUtility.createUser(p);
        u6.SalesReportingGroup__c='Student Services';
        
        User u7 =TestMethodUtility.createUser(p);
        u7.SalesReportingGroup__c='Collaborate';
        
        Luser.Add(u1);
        Luser.Add(u2);
        Luser.Add(u3);
        Luser.Add(u4);
        Luser.Add(u5);
        Luser.Add(u6);
        Luser.Add(u7);
        Insert Luser;
        
      
      
        //Create TEST Account
        List<Account> Lacc = New List<Account>();
        Account account1 = TestMethodUtility.createAccount();
        account1.CustomerofLearn__c=TRUE;
        account1.CustomerofConnect__c=TRUE;
        account1.CustomerofTransact__c=TRUE;
        account1.CustomerofMobile__c=TRUE;
        account1.CustomerofAnalytics__c=TRUE;
        account1.CustomerofStudentServices__c=TRUE;
        account1.CustomerofCollaborate__c=TRUE;
        Lacc.add(account1);
        
        Account account2 =TestMethodUtility.createAccount();
        account2.CustomerofLearn__c=False;
        account2.CustomerofConnect__c=False;
        account2.CustomerofTransact__c=False;
        account2.CustomerofMobile__c=False;
        account2.CustomerofAnalytics__c=False;
        account2.CustomerofStudentServices__c=False;
        account2.CustomerofCollaborate__c=False; 
        Lacc.add(account2);
        
        Insert Lacc;
        
        //Test Opportunity
        List<Opportunity> Lopp = New List<Opportunity>();
        
        Opportunity opportunity1 = new Opportunity(Ownerid=u1.id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account1.Id);
        Opportunity opportunity1a = new Opportunity(Ownerid=u1.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity2 = new Opportunity(Ownerid=u2.id,AccountID = account1.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity2a = new Opportunity(Ownerid=u2.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity3 = new Opportunity( Ownerid=u3.id,AccountID = account1.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity3a = new Opportunity( Ownerid=u3.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity4 = new Opportunity( Ownerid=u4.id,AccountID = account1.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity4a = new Opportunity( Ownerid=u4.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity5 = new Opportunity( Ownerid=u5.id,AccountID = account1.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity5a = new Opportunity( Ownerid=u5.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity6 = new Opportunity( Ownerid=u6.id,AccountID = account1.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity6a = new Opportunity( Ownerid=u6.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity7 = new Opportunity( Ownerid=u7.id,AccountID = account1.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Opportunity opportunity7a = new Opportunity( Ownerid=u7.id,AccountID = account2.Id,Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today());
        Lopp.Add(opportunity1);
        Lopp.Add(opportunity1a);
        Lopp.Add(opportunity2);
        Lopp.Add(opportunity2a);
        Lopp.Add(opportunity3);
        Lopp.Add(opportunity3a);
        Lopp.Add(opportunity4);
        //Lopp.Add(opportunity4a);
        //Lopp.Add(opportunity5);
        //Lopp.Add(opportunity5a);
        //Lopp.Add(opportunity6);
        //Lopp.Add(opportunity6a);
        //Lopp.Add(opportunity7);
        //Lopp.Add(opportunity7a);
        
        Insert Lopp;
        
       } 
     */  
}