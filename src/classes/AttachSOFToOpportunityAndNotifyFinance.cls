/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          AttachSOFToOpportunityAndNotifyFinance
    @abstract       email service that attaches a SOF in form of a Word document to an existing Opportunity, and creates a notification task for finance ops.
    @since          2011.0715
    @discussion     Class to add OpportunityLineItems to an existing Opportunity
*/

global class AttachSOFToOpportunityAndNotifyFinance implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                           Messaging.InboundEnvelope env){
        
        // Create an inboundEmailResult object for returning the result of the Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        result.success = false;
        
        Opportunity opportunity;
        
        // Verify the Account Id in the Email subject is valid
        try{
            String opportunityIdentifier = email.subject == null?email.subject:email.subject.trim();
            opportunity = [SELECT Id, Name, CurrencyIsoCode, Amount, Opportunity_Number_New__c, Account.Name, Account.BillingCountry, Account.BillingState, Comments_for_Finance__c FROM Opportunity WHERE Platform__c INCLUDES ('Collaborate') AND ( Opportunity_Number_New__c = :opportunityIdentifier OR Id = :opportunityIdentifier ) LIMIT 1];
        }
        catch (System.QueryException e) {
                System.debug('Opportunity Query Issue: ' + e);
                result.message = 'Your SOF review request could not be processed because of the following error: \'' + email.subject + '\' is not a valid Opportunity Number. Make sure that the email subject is the CL number, or the Opportunity Id (ONLY) in order to be processed.';
                return result;
        }   

        if(opportunity != null) {
            Messaging.InboundEmail.BinaryAttachment[] attachments = email.binaryAttachments;
            for(Messaging.InboundEmail.BinaryAttachment attachment:attachments)
            {
            
                System.debug ('mimeTypeSubType -> ' + attachment.mimeTypeSubType);
                String extension = '';
                if(attachment.mimeTypeSubType == 'application/msword' || attachment.mimeTypeSubType == 'application/x-msword' || attachment.mimeTypeSubType == 'application/doc' || attachment.mimeTypeSubType == 'application/msword-doc' || attachment.mimeTypeSubType == 'application/x-msword-doc' || attachment.mimeTypeSubType == 'application/word') extension = '.doc';
                else if(attachment.mimeTypeSubType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') extension = '.docx';

                if(extension == '.doc' || extension == '.docx') {
                    String attachmentName = opportunity.Account.Name + ' SOF ' + opportunity.Opportunity_Number_New__c + ' ' + String.valueOf(Date.today()) + extension;
                    Blob body = attachment.body;
                    Attachment sof = new Attachment(Body = body, ParentId = opportunity.Id, Name = attachmentName);      
                
                    insert sof;
                    System.debug ('Stored SOF  -> ' + attachmentName + ' for Opportunity ' + opportunity.Name);
                }
            }

            Task taskForFinanceOpps = new Task();
            taskForFinanceOpps.WhatId = opportunity.Id;
            taskForFinanceOpps.Subject = 'Review SOF - ' + opportunity.CurrencyIsoCode + ' ' + opportunity.Amount + ' - ' + opportunity.Account.BillingCountry + ' - ' + opportunity.Account.BillingState + ' - ' + opportunity.Opportunity_Number_New__c;
            taskForFinanceOpps.ActivityDate = Date.today().addDays(1);
            taskForFinanceOpps.OwnerId = '00570000001SXGP';//It is the SF-FinanceOps user;
            taskForFinanceOpps.Type = 'Other'; 
            taskForFinanceOpps.Description = opportunity.Comments_for_Finance__c + '\n\n' + email.plainTextBody; 
            Database.DMLOptions dlo = new Database.DMLOptions(); 
            dlo.EmailHeader.triggerUserEmail = true; 
            database.insert(taskForFinanceOpps, dlo); 
        
            result.success = true;
        }
        // Return the result for the Apex Email Service
        return result;
    }
 static testmethod void Attachsofttest() {
 
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
}