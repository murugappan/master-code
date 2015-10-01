/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          ConvertEmailToDocAndNotifyFinance
    @abstract       email service that converts a welcome email into a word document and sends it to finance.
    @since          2011.0715
    @discussion     Class to convert Email into MS Word document and notify Finance
*/

/** TODO
    - setToAddresses should be the Finance user
*/
global class ConvertEmailToDocAndNotifyFinance implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                           Messaging.InboundEnvelope env){
        
        // Create an inboundEmailResult object for returning the result of the Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        result.success = false;
        
        // The content of the attachment from the pdf
        Blob attachmentbody;
        if(email.htmlBody != null) attachmentbody = Blob.valueOf(email.htmlBody);
        else attachmentbody = Blob.valueOf(email.plainTextBody);
 
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/x-msword');
        attach.setFileName('Welcome Email.docx');
        attach.setInline(false);
        attach.Body = attachmentbody;
 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { 'etienne.coutant@blackboard.com' });
        mail.setSubject('Blackboard Collaboarte Welcome email hardcopy');
        
        String body = 'Please find attached a hardcopy of the Blackboard Collaborate welcome email ' + email.subject + '<br/>';
        body += 'From: ' + email.fromName + '  ' + email.fromAddress + '<br/>';
        body += 'To: ';
        for(String toAddress:email.toAddresses) body += toAddress + '  ';
        body += '<br/>';
        body += 'Date: ';
        for(Messaging.InboundEmail.Header emailHeader:email.headers) if(emailHeader.Name == 'Date') body += emailHeader.Value;
        body += '<br/><br/><br/>';
        mail.setHtmlBody(body);
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
 
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 
        result.success = true;
        
        // Return the result for the Apex Email Service
        return result;
 
  }
}