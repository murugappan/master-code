/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestEmailServices
    @abstract       Unit Test for all email services defined in Salesforce
    @since          2011.0715
    @discussion     Test Class for Email Services
*/


@isTest
private class TestEmailServices {

    static testMethod void attachSOFToOpportunityAndNotifyFinanceTest() {

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        Product2 pr = TestMethodUtility.createProduct();
        pr.Product_Category__c = 'Web Conferencing' ;
        pr.Product_Sub_Category__c = 'SAAS';
        pr.Isactive=True;
        insert pr;
        
        Pricebook2 pribook= TestMethodUtility.createPricebook();
        pribook.Name='Bb Collaborate NA';
        
        insert pribook;
        
        
        Pricebook2 pri=[Select id from Pricebook2 where Name='Standard Price Book' and isstandard=True limit 1];
        PriceBookEntry elive1 = TestMethodUtility.createPriceBookEntry(pri,pr);
        insert elive1;
        
        PriceBookEntry elive = TestMethodUtility.createPriceBookEntry(pribook,pr);
        insert elive ;
        /*
        PriceBookEntry elive = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Bb Collaborate NA' 
                                    AND Product2.Product_Category__c = 'Web Conferencing' 
                                    AND Product2.Product_Sub_Category__c = 'SAAS' 
                                    AND CurrencyIsoCode = 'USD'
                                    AND isActive = true
                                    ORDER BY Name
                                    LIMIT 1];
        */
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        OpportunityLineItem item1 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = elive.Id, Quantity = 1, UnitPrice = 4324);
        insert item1;
        System.assertNotEquals(item1.Id, null);

        // *************************Test with Attachment and invalid subject
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        
        email.subject = opportunity.Opportunity_Number_New__c; //It will be empty as we did not query the Opportunity
        env.fromAddress = UserInfo.getFirstName() + '.' + UserInfo.getLastName() + '@blackboard.com';
        
        // set the body of the attachment
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name.doc';
        inAtt.mimeTypeSubType = 'application/msword';
        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt}; 
        
        // call the class and test it with the data in the testMethod
        AttachSOFToOpportunityAndNotifyFinance emailServiceObj = new AttachSOFToOpportunityAndNotifyFinance();
        Messaging.InboundEmailResult result;
        try{
           result = emailServiceObj.handleInboundEmail(email, env);   
        } 
        catch(System.QueryException e) {
            System.assertEquals(result,null);
        }
        catch(System.StringException e) {
            System.assertEquals(result,null);
        }



        // *************************Test with Attachment and valid subject
        // Create a new email, envelope object and Attachment
        email = new Messaging.InboundEmail();
        env = new Messaging.InboundEnvelope();
        inAtt = new Messaging.InboundEmail.BinaryAttachment();
        
        email.subject = [SELECT Id, Opportunity_Number_New__c FROM Opportunity WHERE Id =: opportunity.Id].Opportunity_Number_New__c;
        env.fromAddress = UserInfo.getFirstName() + '.' + UserInfo.getLastName() + '@blackboard.com';
        
        // set the body of the attachment
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name.doc';
        inAtt.mimeTypeSubType = 'application/msword';
        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt}; 
        
        // call the class and test it with the data in the testMethod
        emailServiceObj = new AttachSOFToOpportunityAndNotifyFinance();
        try{
           result = emailServiceObj.handleInboundEmail(email, env);   
        } 
        catch(System.QueryException e) {
            System.assertEquals(result,null);
        }
        catch(System.StringException e) {
            System.assertEquals(result,null);
        }
        //System.assertNotEquals(result,null);
        //System.assert(result.success);
    }
    
    static testMethod void ConvertEmailToDocAndNotifyFinanceTest() {

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        // *************************Test with Attachment and invalid subject
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'Test';
        email.htmlBody = '<html><body> HTML here ... </body></html>';
        email.fromAddress = UserInfo.getFirstName() + '.' + UserInfo.getLastName() + '@blackboard.com';
        email.toAddresses = new String[]{UserInfo.getFirstName() + '.' + UserInfo.getLastName() + '@blackboard.com'};
        email.headers = new List<Messaging.InboundEmail.Header>();
        
        
        // call the class and test it with the data in the testMethod
        ConvertEmailToDocAndNotifyFinance emailServiceObj = new ConvertEmailToDocAndNotifyFinance();
        Messaging.InboundEmailResult result;
        try{
           result = emailServiceObj.handleInboundEmail(email, env);   
        } 
        catch(System.QueryException e) {
            System.assertEquals(result,null);
        }
        catch(System.StringException e) {
            System.assertEquals(result,null);
        }

        System.assertNotEquals(result,null);
        System.assert(result.success);
    }
}