/*
Class:AttachSOFToOpportunityAndNotifyFinance
Date:21.05.2013
*/
@isTest(seealldata=True)
private class AttachSOFToOpportunityAndNotifyFinantest {

    static testMethod void myUnitTest() {
        
        
            Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
     
            Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
               insert account; 
               
              Opportunity opportunity = new Opportunity(Name = 'Apex Test',Platform__c= 'Collaborate', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'Pilot', Contract__c = 'Annual', StageName = '(S) Suspect Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
              insert opportunity;  
              
            Opportunity opp = [SELECT Id, Name, CurrencyIsoCode, Amount, Opportunity_Number_New__c, Account.Name, Account.BillingCountry, Account.BillingState, Comments_for_Finance__c FROM Opportunity where id =:opportunity.id]; 
         
            Messaging.InboundEmail inemail = new Messaging.InboundEmail();
            inemail.fromAddress = 'prakashb6687@gmail.com';
            inemail.htmlBody = 'hello';
            inemail.subject = opp.Opportunity_Number_New__c;
            Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
            Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
            binaryAttachment.Filename = 'test.doc';
            binaryAttachment.mimeTypeSubType ='application/msword';
            String algorithmName = 'HMacSHA1';
            Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
            Blob.valueOf('test_key'));
            binaryAttachment.Body = b;
            binaryAttachments[0] =  binaryAttachment ;
            inemail.binaryAttachments = binaryAttachments;
        
            
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            env.fromAddress = 'nikhil886846@gmail.com';
            
            AttachSOFToOpportunityAndNotifyFinance emailtocase = new AttachSOFToOpportunityAndNotifyFinance();
            emailtocase.handleInboundEmail(inemail,env);
 
   }   
   
       static testMethod void myUnitTest1() {  
        
        Opportunity opportunity= new Opportunity();
        
        
        Messaging.InboundEmail inemail = new Messaging.InboundEmail();
        inemail.fromAddress = 'prakashb6687@gmail.com';
        inemail.htmlBody = 'hello';
        inemail.subject = 'Test subject';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.doc';
        binaryAttachment.mimeTypeSubType ='application/msword';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        inemail.binaryAttachments = binaryAttachments;
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        env.fromAddress = 'nikhil886846@gmail.com';
        
        
        AttachSOFToOpportunityAndNotifyFinance emailtocase = new AttachSOFToOpportunityAndNotifyFinance();
        emailtocase.handleInboundEmail(inemail,env);
        
        
       }
     
     
     
     
    }