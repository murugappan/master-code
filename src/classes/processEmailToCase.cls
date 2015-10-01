global class processEmailToCase implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env) {
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    List<string>Mailattributesbody;
        List<String> MailAttributes = String.valueOf(email.Subject).split('%');
        if(email.HtmlBody != null && email.HtmlBody != ''){
        Mailattributesbody=string.valueof(email.htmlbody).split('%#');
        }
        else if(email.plaintextBody != null && email.plaintextBody != '') {
            Mailattributesbody=string.valueof(email.plaintextBody).split('%#');
        }  
        EmailMessage inboundemail = new EmailMessage();
        Datetime t = System.now();
        Case_Note__c cn = new Case_Note__c();
        system.debug('subject--'+ MailAttributes);
      try  {    
        String CaseId;
        String Workflow;
        /*Force.com Sandbox: Case Number:01417196 Need More Information %01417196%Need More Info%*/
        try{
         CaseId = MailAttributes[1];
         if(MailAttributes[2] == 'has been created') //TP4282
         {
            Exception e;
             throw  e;
         }
        if(MailAttributes[2] == 'Case needs attention')
        {

            Workflow = 'Need More Info';
        }
        else if(MailAttributes[2] == 'Comment Added' || MailAttributes[2] == 'has been Escalated' )
        {
          workflow='Update Client';
        }
        else
            Workflow = MailAttributes[2];
        }
        catch(exception e)
        {
         CaseId = Mailattributesbody[1];
         
        if(Mailattributesbody[2] == 'Case needs attention')
            Workflow = 'Need More Info';
        else
            Workflow = Mailattributesbody[2];
        }
        List<Support_Workflow__c> relatedWorkflows = new List<Support_Workflow__c>();
        
                List<Case> relatedCases = [Select Id,AssignTo_Comment__c,casenumber,subject, Case_record__c,  BusinessHoursID,IsClosed , Case_Severity__c, Contact_Response_Initiated__c, Primary_Group_Name__c, OwnerId, Status,Customer_Portal_Status__c,Send_email_client_case_team__c,recordtype.name From Case Where CaseNumber = :CaseId Limit 1];        
        if(!(relatedCases.size()>0))
        {
         CaseId = Mailattributesbody[1];
         
        if(Mailattributesbody[2] == 'Case needs attention')
            Workflow = 'Need More Info';
        else
            Workflow = Mailattributesbody[2];
        relatedCases = [Select Id,AssignTo_Comment__c,casenumber,subject, Case_record__c,  BusinessHoursID,IsClosed , Case_Severity__c, Contact_Response_Initiated__c, Primary_Group_Name__c, OwnerId, Status,Customer_Portal_Status__c,Send_email_client_case_team__c,recordtype.name From Case Where CaseNumber = :CaseId Limit 1];
        }
        if(relatedCases.size()>0){

            if(Workflow == 'Close Case'){
               if(relatedCases[0].Case_record__c != null && (relatedCases[0].Case_record__c.contains('ANGEL') ||  relatedCases[0].Case_record__c.contains('Learn') || relatedCases[0].Case_record__c.contains('Vista')))            
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow AND Close_Case_License__c = 'Learn and ANGEL'];
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Transact'))
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow AND Close_Case_License__c = 'Transact'];
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Xythos'))
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow AND Close_Case_License__c = 'Xythos'];
            }else
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow];
     
     if(!(relatedWorkflows.size()>0))
     {
     
      CaseId = Mailattributesbody[1];
      
        if(Mailattributesbody[2] == 'Case needs attention')
            Workflow = 'Need More Info';
        else
            Workflow = Mailattributesbody[2];
     if(Workflow == 'Close Case'){
               if((relatedCases[0].Case_record__c != null && (relatedCases[0].Case_record__c.contains('ANGEL') ||  relatedCases[0].Case_record__c.contains('Learn') || relatedCases[0].Case_record__c.contains('Vista') || relatedCases[0].Case_record__c.containsignorecase('Collaborate')))||(relatedCases[0].recordtype.name.containsignorecase('end user')))            
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow AND Close_Case_License__c = 'Learn and ANGEL' ];
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Transact'))
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow AND Close_Case_License__c = 'Transact'];
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Xythos'))
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow AND Close_Case_License__c = 'Xythos'];
            }else
                  relatedWorkflows = [Select Name, Reply_Status_Update__c, Reply_Portal_Status_Update__c From Support_Workflow__c Where Name = :Workflow ];
     }
 
           if(relatedWorkflows[0].Reply_Status_Update__c != Null && relatedWorkflows[0].Reply_Portal_Status_Update__c != Null){
                if(relatedCases[0].isClosed == true){
                    relatedCases[0].Status = 'Reopened';
              //      relatedCases[0].Portal_Status__c = 'Work In Progress';
                    List<Solution_Detail__c> soldet = new List<Solution_Detail__c>();
                    soldet = [select ID,Status__c from Solution_Detail__c where Case__c =:relatedCases[0].id and Status__c = 'Successful Resolution' ORDER BY LastModifiedDate DESC Limit 1];
                    if(soldet != null && soldet.size() > 0){
                        soldet[0].Status__c = 'Failed Resolution';
                        Update soldet[0];
                    } 
                     List<Solution_Detail__c> sdlist = new List<Solution_Detail__c>();
                   for(Solution_Detail__c sd1 : [select Id,Name from Solution_Detail__c where Case__c =:relatedCases[0].id AND Status__c = 'In Consideration']){
                      Solution_Detail__c sd2 = new Solution_Detail__c(ID = sd1.id);
                        sd2.Status__c = 'Not Considered';
                       sdlist.add(sd2);
                      }
                   if(sdlist.size()>0)
                   Update sdlist;                                       
                }else{
                    relatedCases[0].Status = relatedWorkflows[0].Reply_Status_Update__c;
                     List<Solution_Detail__c> sdlist = new List<Solution_Detail__c>();
                   for(Solution_Detail__c sd1 : [select Id,Name from Solution_Detail__c where Case__c =:relatedCases[0].id AND Status__c = 'In Consideration']){
                      Solution_Detail__c sd2 = new Solution_Detail__c(ID = sd1.id);
                        sd2.Status__c = 'Not Considered';
                       sdlist.add(sd2);
                   }
                   if(sdlist.size()>0)
                   Update sdlist;
                   // relatedCases[0].Portal_Status__c = relatedWorkflows[0].Reply_Portal_Status_Update__c;
                }
                relatedCases[0].Last_Activity_Date_Time__c = System.now();
                if(email.HtmlBody != null && email.HtmlBody != '')
                {
                    if(email.HtmlBody.length()>=32768)
                    {
                relatedCases[0].AssignTo_Comment__c = email.HtmlBody.substring(0,32768);
                    }
                    else
                    {
               relatedCases[0].AssignTo_Comment__c = email.HtmlBody;
                    }
                    
                } 
                else if(email.plaintextBody != null && email.plaintextBody != '') {
                    if(email.plaintextBody.length()>=32768)
                    relatedCases[0].AssignTo_Comment__c = email.plaintextbody.substring(0,32768);
                    else
                    relatedCases[0].AssignTo_Comment__c = email.plaintextbody;
                   }
             try{            
                if(relatedCases[0].Send_email_client_case_team__c!= null)
                {
                relatedCases[0].Send_email_client_case_team__c=relatedCases[0].Send_email_client_case_team__c+1;
                }
                else
                {
                relatedCases[0].Send_email_client_case_team__c=1;
                }
                update relatedCases;
                Non_Time_based_Alerts NTB= new Non_Time_based_Alerts ();
                string body=NTB.getBody('clientcomment',relatedCases[0]);
                string subject='Case#'+relatedCases[0].casenumber+'  has been updated by the client';
                emailviaworkflow.mailStaffCaseTeam(relatedCases[0],body,subject );
 
            }
            catch (Exception ex){
                 error_log__c  err_log= new error_log__c();
                 err_log.Error_message__c=Ex.getmessage();
                 err_log.UserID__c=Userinfo.getuserid();
                 err_log.profileID__c=Userinfo.getprofileid();
                 err_log.Line_Number__c=Ex.getLineNumber();
                 err_log.StackTrace__c=Ex.getstacktracestring();
                 err_log.Type__c=Ex.getTypeName();
                 err_log.Related_Record__c=relatedCases[0].id;
                 insert err_log;
            }
            }// Case Email
            // -- Response Event Handling 
            try{
              // Businesshours  bh;
               Decimal sla;
             //  bh = [select id from businesshours where ID =: relatedCases[0].BusinessHoursID];
               if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('ANGEL'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'ANGEL'].SLA__c;
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Learn'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'Learn'].SLA__c;
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('CE'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'CE'].SLA__c;
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Xythos'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'Xythos'].SLA__c;
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Transact'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'Transact'].SLA__c;
               else if((relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Collaborate'))||(relatedCases[0].recordtype.name.containsignorecase('end user')))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'Collaborate'].SLA__c;
               else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Moodlerooms'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'Moodlerooms'].SLA__c;    
              else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Analytics'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'Analytics'].SLA__c;    
              else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('xpLor'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases[0].Case_Severity__c AND Core_License__c = 'xpLor'].SLA__c;  


               String ownername; 

               if(String.valueof(relatedCases[0].OwnerId).substring(0,3) == '005'){
                  User u = [select Id,FirstName,LastName from User where ID =: String.valueof(relatedCases[0].OwnerId)];
                  ownername = u.FirstName + u.LastName;
               }
               Responsiveness__c res = new Responsiveness__c();
               res.Case__c = relatedCases[0].ID;
               res.Start_Time__c = System.now();
               res.Start_Event__c = 'Client Email';
               res.Event_Type__c= 'Follow Up';
               if(String.valueof(relatedCases[0].OwnerId).substring(0,3) == '005'){
                    User u1 = [select Name,Primary_Group__c from User where ID =: relatedCases[0].OwnerId]; 
                    res.Event_Owner__c = u1.Name;
                    res.Event_Owner_Primary_Group__c = u1.Primary_Group__c;
               }else{
                  res.Event_Owner__c = relatedCases[0].Primary_Group_Name__c;
                  res.Event_Owner_Primary_Group__c = relatedCases[0].Primary_Group_Name__c;
               }
               
               BusinessHours b1 = [select ID from BusinessHours where Name = 'Default']; 
               if(sla != null){
                   if(relatedCases[0].Case_Severity__c == '1' || relatedCases[0].Case_Severity__c == '2'){    
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID,System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                   }else{
                        String day = System.now().format('EEE');
                        if(day == 'Fri')
                           res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 48) * 60 * 60 * 1000L);
                        else if(day == 'Sat')
                           res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 24) * 60 * 60 * 1000L);
                        else
                           res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                    }
                } 
               Insert res;
            
               if(relatedCases[0].IsClosed == false){
                  if(relatedCases[0].Contact_Response_Initiated__c == false){
                     relatedCases[0].Contact_Response_Initiated__c = true;
                     Update relatedCases[0];
                  }
                  List<CaseMilestone> cm = new List<CaseMilestone>([select ID,StartDate,CompletionDate from CaseMilestone where CaseID =: relatedCases[0].ID AND MilestoneType.Name = 'Contact Response']);
                  if(cm != null && cm.size() > 0){
                     if((relatedCases[0].Contact_Response_Initiated__c == false && cm[0].CompletionDate == null) || cm[0].CompletionDate != null){
                         CaseMilestone cm1 = new CaseMilestone(Id = cm[0].ID);
                         cm1.StartDate = System.now();
                         cm1.CompletionDate = null;
                         Update cm1;
                     }
                  }
               } 
            }
            catch(Exception ex) {
                 error_log__c  err_log= new error_log__c();
                 err_log.Error_message__c=Ex.getmessage();
                 err_log.UserID__c=Userinfo.getuserid();
                 err_log.profileID__c=Userinfo.getprofileid();
                 err_log.Line_Number__c=Ex.getLineNumber();
                 err_log.StackTrace__c=Ex.getstacktracestring();
                 err_log.Type__c=Ex.getTypeName();
                 err_log.Related_Record__c=relatedCases[0].id;
                 insert err_log;
            
            }
           //  end Response Event Handling -- 
            try
            {
            
                cn.Type__c = 'Email';
                cn.Incoming_Outgoing__c = 'Incoming';
                cn.Email_Subject__c = email.fromName+' | '+email.subject;
                if(email.HtmlBody != null && email.HtmlBody != '')
                {
                    if(email.HtmlBody.length()>=32768)
                    {
                    cn.Details__c = email.HtmlBody.substring(0,32700)+'<br/>[Message Clipped]....';
                    }
                    else
                    {
                    cn.Details__c = email.HtmlBody;
                    }
                }
                else if(email.plainTextBody != null && email.plainTextBody != '')
                {
                 if(email.plainTextBody.length() >= 32768)
                 {
                    cn.Details__c = email.plainTextBody.substring(0,32700)+'\n[Message Clipped]....';
                 }
                 else
                 {
                 cn.Details__c = email.plainTextBody;   
                 }  
                }
                    
                cn.Public__c = true;
                cn.Case__c = relatedCases[0].Id;
                cn.From_Type__c = 'Contact';
                cn.From_Address__c = email.fromName+'<'+email.fromAddress+'>';
                cn.is_Email__c = true;
                cn.Processed_By_Email_Service__c = true;
                
                insert cn;
                
                inboundemail.MessageDate = t;
                inboundemail.Status = '0';
                inboundemail.fromAddress = email.fromAddress;
                inboundemail.subject  = email.subject;
                if(email.HtmlBody != null && email.HtmlBody != ''){
                if(email.HtmlBody.length()>=32000)
                    {
                        system.debug('Entered If 1--'+email.HtmlBody.length());
                    inboundemail.HtmlBody ='<div id="testid_div">'+ email.HtmlBody.substring(0,31900)+'<br/>[Message Clipped]....</div>';
                    if(email.plainTextBody != null && email.plainTextBody.length() >= 32000)
                    inboundemail.textbody=email.plainTextBody.substring(0,31900)+'\n[Message Clipped]....'; 
                    else
                    inboundemail.textbody=email.plainTextBody;
                    }
                    else
                    {
                    inboundemail.HtmlBody = email.HtmlBody;
                    }
            }
                else if (email.plainTextBody != null && email.plainTextBody != '')
                {
                    system.debug('Entered If 2--'+email.plainTextBody.length());
                    if(email.plainTextBody.replaceAll('[\\n]|[\\r]','<br/>').length() >= 32000)
                    {
                    inboundemail.textbody=email.plainTextBody.substring(0,31950)+'<br/>[Message Clipped]....';  
                string temp = email.plaintextBody.replaceAll('[\\n]|[\\r]','<br/>');
                    inboundemail.htmlBody = temp.substring(0,31950)+'<br/>[Message Clipped]....';
                    }
                    else
                    {
                    string temp = email.plaintextBody;  
                    inboundemail.textbody=email.plaintextBody;
                    string temp2 = temp.replaceAll('[\\n]|[\\r]','<br/>');
                    if(temp2.length()>=32000)
                    {                   
                    inboundemail.htmlBody = temp2.substring(0,31950)+'<br/>[Message Clipped]....';  
                    }
                    else                 
                    inboundemail.htmlBody = temp2;
                    }
                }    
                inboundemail.fromName = email.fromName;
                inboundemail.ParentId = relatedCases[0].Id;
                inboundemail.Incoming = true;
                
                insert inboundemail;
                
                if(email.HtmlBody != null && email.HtmlBody != ''){
                if(email.HtmlBody.length()>=32000)
                {
                Attachment attachment_emailbody = new Attachment();
                    attachment_emailbody.Name = 'CompleteMail.html';
                    attachment_emailbody.Body = Blob.valueOf(email.HtmlBody);            
                    attachment_emailbody.ParentId = inboundemail.id;
                    insert attachment_emailbody;    
                }
                }
                else if(email.plaintextBody != null && email.plaintextBody != ''){
                if(email.plaintextBody.length()>=32000)
                {
                Attachment attachment_emailbody = new Attachment();
                    attachment_emailbody.Name = 'CompleteMail.txt';
                    attachment_emailbody.Body = Blob.valueOf(email.plaintextBody);            
                    attachment_emailbody.ParentId = inboundemail.id;
                    insert attachment_emailbody;    
                }
                }
                
                // Saving the email body as attachment if its too large.
                
                
                
                result.success = true;
                //result.message = 'success!! apex class processEmailToCase debugger';
            }
            catch (Exception ex){
             error_log__c  err_log= new error_log__c();
                 err_log.Error_message__c=Ex.getmessage();
                 err_log.UserID__c=Userinfo.getuserid();
                 err_log.profileID__c=Userinfo.getprofileid();
                 err_log.Line_Number__c=Ex.getLineNumber();
                 err_log.StackTrace__c=Ex.getstacktracestring();
                 err_log.Type__c=Ex.getTypeName();
                 err_log.Related_Record__c=relatedCases[0].id;
                 insert err_log;
            result.success = false;
            //result.message = 'failed!! apex class processEmailToCase debugger'+e.getMessage();
            
            }
            
            // Attachment
            try
            {
            
            if(email.textAttachments != null && email.textAttachments.size() > 0){    
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = inboundemail.id;
                    insert attachment;
                }
            }        
            if(email.binaryAttachments != null && email.binaryAttachments.size() > 0){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();     
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    System.debug('<<<<<<<<Before Insert 222>>>>>>>>>>');
                    attachment.ParentId = inboundemail.id;
                    insert attachment;   
                }
           } 
      }
              catch (Exception ex){
                 error_log__c  err_log= new error_log__c();
                 err_log.Error_message__c=Ex.getmessage();
                 err_log.UserID__c=Userinfo.getuserid();
                 err_log.profileID__c=Userinfo.getprofileid();
                 err_log.Line_Number__c=Ex.getLineNumber();
                 err_log.StackTrace__c=Ex.getstacktracestring();
                 err_log.Type__c=Ex.getTypeName();
                 err_log.Related_Record__c=relatedCases[0].id;
                 insert err_log;
                result.success = false;
                //result.message = 'attachments failed!!! debug processEmailtoCase Email Services'+e.getMessage();
            }
        
    
    }
    return result;  
  }
  catch(exception e)
  {
    
  //final catch
  list<string> subject_attributes = new list<string>();
  if(email.Subject.contains('has been created'))
  {
  
  try
  {
    subject_attributes = String.valueOf(email.Subject).split('%');
  string case_no = subject_attributes[1];
  case c = [Select Id,AssignTo_Comment__c,casenumber,subject, Case_record__c,  BusinessHoursID,IsClosed , Case_Severity__c, Contact_Response_Initiated__c, Primary_Group_Name__c, OwnerId, Status,Customer_Portal_Status__c,Send_email_client_case_team__c,recordtype.name from case where casenumber =:case_no];
 // c.status='Needs Attention';
 try{ 
    // Businesshours  bh;
               Decimal sla;
      //         bh = [select id from businesshours where ID =: c.BusinessHoursID];
               if(c.Case_record__c != null && c.Case_record__c.contains('ANGEL'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'ANGEL'].SLA__c;
               else if(c.Case_record__c != null && c.Case_record__c.contains('Learn'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Learn'].SLA__c;
               else if(c.Case_record__c != null && c.Case_record__c.contains('CE'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'CE'].SLA__c;
               else if(c.Case_record__c != null && c.Case_record__c.contains('Xythos'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Xythos'].SLA__c;
               else if(c.Case_record__c != null && c.Case_record__c.contains('Transact'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Transact'].SLA__c;
               else if((c.Case_record__c != null && c.Case_record__c.contains('Collaborate'))||(c.recordtype.name.containsignorecase('end user')))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Collaborate'].SLA__c;

               String ownername; 

               if(String.valueof(c.OwnerId).substring(0,3) == '005'){
                  User u = [select Id,FirstName,LastName from User where ID =: String.valueof(c.OwnerId)];
                  ownername = u.FirstName + u.LastName;
               }
               Responsiveness__c res = new Responsiveness__c();
               res.Case__c = c.ID;
               res.Start_Time__c = System.now();
               res.Start_Event__c = 'Client Email';
               res.Event_Type__c= 'Follow Up';
               if(String.valueof(c.OwnerId).substring(0,3) == '005'){
                    User u1 = [select Name,Primary_Group__c from User where ID =: c.OwnerId]; 
                    res.Event_Owner__c = u1.Name;
                    res.Event_Owner_Primary_Group__c = u1.Primary_Group__c;
               }else{
                  res.Event_Owner__c = c.Primary_Group_Name__c;
                  res.Event_Owner_Primary_Group__c = c.Primary_Group_Name__c;
               }
               
               BusinessHours b1 = [select ID from BusinessHours where Name = 'Default']; 
               if(sla != null){
                   if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2'){    
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID,System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                   }else{
                        String day = System.now().format('EEE');
                        if(day == 'Fri')
                           res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 48) * 60 * 60 * 1000L);
                        else if(day == 'Sat')
                           res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 24) * 60 * 60 * 1000L);
                        else
                           res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                    }
                } 
               Insert res;
  } 
 catch(exception ex)
 {
     error_log__c  err_log= new error_log__c();
                 err_log.Error_message__c=Ex.getmessage();
                 err_log.UserID__c=Userinfo.getuserid();
                 err_log.profileID__c=Userinfo.getprofileid();
                 err_log.Line_Number__c=Ex.getLineNumber();
                 err_log.StackTrace__c=Ex.getstacktracestring();
                 err_log.Type__c=Ex.getTypeName();
                 err_log.Related_Record__c=c.id;
                 insert err_log;
 } 
  
  
  
                cn.Type__c = 'Email';
                cn.Incoming_Outgoing__c = 'Incoming';
                cn.Email_Subject__c = email.fromName+' | '+email.subject;
                 if(email.HtmlBody != null && email.HtmlBody != '')
                {
                    if(email.HtmlBody.length()>=32768)
                    {
                    cn.Details__c = email.HtmlBody.substring(0,32700)+'<br/>[Message Clipped]....';
                    }
                    else
                    {
                    cn.Details__c = email.HtmlBody;
                    }
                }
                else if(email.plainTextBody != null && email.plainTextBody != '')
                {
                 if(email.plainTextBody.length() >= 32768)
                 {
                    cn.Details__c = email.plainTextBody.substring(0,32700)+'\n[Message Clipped]....';
                 }
                 else
                 {
                 cn.Details__c = email.plainTextBody;   
                 }  
                }
                cn.Public__c = true;
                cn.Case__c = c.Id;
                cn.From_Type__c = 'Contact';
                cn.From_Address__c = email.fromName+'<'+email.fromAddress+'>';
                cn.is_Email__c = true;
                cn.Processed_By_Email_Service__c = true;
                
                insert cn;
                
                inboundemail.MessageDate = t;
                inboundemail.Status = '0';
                inboundemail.fromAddress = email.fromAddress;
                inboundemail.subject  = email.subject;
           if(email.HtmlBody != null && email.HtmlBody != ''){
                if(email.HtmlBody.length()>=32000)
                    {
                        system.debug('Entered If 1--'+email.HtmlBody.length());
                    inboundemail.HtmlBody ='<div id="testid_div">'+ email.HtmlBody.substring(0,31900)+'<br/>[Message Clipped]....</div>';
                    if(email.plainTextBody != null && email.plainTextBody.length() >= 32000)
                    inboundemail.textbody=email.plainTextBody.substring(0,31900)+'\n[Message Clipped]....'; 
                    else
                    inboundemail.textbody=email.plainTextBody;
                    }
                    else
                    {
                    inboundemail.HtmlBody = email.HtmlBody;
                    }
            }
                else if (email.plainTextBody != null && email.plainTextBody != '')
                {
                    system.debug('Entered If 2--'+email.plainTextBody.length());
                    if(email.plainTextBody.replaceAll('[\\n]|[\\r]','<br/>').length() >= 32000)
                    {
                    inboundemail.textbody=email.plainTextBody.substring(0,31950)+'<br/>[Message Clipped]....';  
                string temp = email.plaintextBody.replaceAll('[\\n]|[\\r]','<br/>');
                    inboundemail.htmlBody = temp.substring(0,31950)+'<br/>[Message Clipped]....';
                    }
                    else
                    {
                    string temp = email.plaintextBody;  
                    inboundemail.textbody=email.plaintextBody;
                    string temp2 = temp.replaceAll('[\\n]|[\\r]','<br/>');
                    if(temp2.length()>=32000)
                    {                   
                    inboundemail.htmlBody = temp2.substring(0,31950)+'<br/>[Message Clipped]....';  
                    }
                    else                 
                    inboundemail.htmlBody = temp2;
                    }
                }     
                inboundemail.fromName = email.fromName;
                inboundemail.ParentId = c.Id;
                inboundemail.Incoming = true;
                
                insert inboundemail;
                
             if(email.HtmlBody != null && email.HtmlBody != ''){
                if(email.HtmlBody.length()>=32000)
                {
                Attachment attachment_emailbody = new Attachment();
                    attachment_emailbody.Name = 'CompleteMail.html';
                    attachment_emailbody.Body = Blob.valueOf(email.HtmlBody);            
                    attachment_emailbody.ParentId = inboundemail.id;
                    insert attachment_emailbody;    
                }
                }
                else if(email.plaintextBody != null && email.plaintextBody != ''){
                if(email.plaintextBody.length()>=32000)
                {
                Attachment attachment_emailbody = new Attachment();
                    attachment_emailbody.Name = 'CompleteMail.txt';
                    attachment_emailbody.Body = Blob.valueOf(email.plaintextBody);            
                    attachment_emailbody.ParentId = inboundemail.id;
                    insert attachment_emailbody;    
                }
                }   
                
                
           if(email.textAttachments != null && email.textAttachments.size() > 0){    
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = inboundemail.id;
                    insert attachment;
                }
            }        
            if(email.binaryAttachments != null && email.binaryAttachments.size() > 0){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();     
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    System.debug('<<<<<<<<Before Insert 222>>>>>>>>>>');
                    attachment.ParentId = inboundemail.id;
                    insert attachment;   
                }
           }          
    update c;
   result.success = true;

  return result;                 
  }
  catch(exception f)
  {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String[] toAddresses = new String[] {email.fromAddress};
      mail.setToAddresses(toAddresses);
    // OrgWideEmailAddress od =[select id,Address from OrgWideEmailAddress where Address='no-reply@blackboard.com' limit 1];
     mail.setSubject('Unable to process your response');
   //  mail.setOrgWideEmailAddressId(od.id);
    mail.setOrgWideEmailAddressId('0D270000000Gmzn');
     string body='Hello,<br/><br/>We were unable to process your email response into the appropriate support case. A possible reason is that the subject line has been changed or truncated. '+
     'Please log into Behind the Blackboard, navigate to the desired case, and re-submit your response either by clicking on the Add Comment button or, if a solution '+
     'has been suggested on your case, by clicking on "Accept" or "Decline" from within the solution comment.<br/><br/>'+
     'Best regards,<br/> Client Support';
      mail.setHTMLBody(body);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      result.success = false;
    
      return result;    
  }
  }else 
  {
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  String[] toAddresses = new String[] {email.fromAddress};
  mail.setToAddresses(toAddresses);
 //OrgWideEmailAddress od =[select id,Address from OrgWideEmailAddress where Address='no-reply@blackboard.com' limit 1];
 mail.setSubject('Unable to process your response');
 //mail.setOrgWideEmailAddressId(od.id);
 mail.setOrgWideEmailAddressId('0D270000000Gmzn');
 string body='Hello,<br/><br/>We were unable to process your email response into the appropriate support case.  A possible reason is that the subject line has been changed or truncated. '+
 'Please log into Behind the Blackboard, navigate to the desired case, and re-submit your response either by clicking on the Add Comment button or, if a solution '+
 'has been suggested on your case, by clicking on "Accept" or "Decline" from within the solution comment.<br/><br/>'+
 'Best regards,<br/> Client Support';
  mail.setHTMLBody(body);
  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  result.success = false;

  return result;
  }
  }
 }

  @isTest static void processEmailToCasetest(){
 
 Profile p = [select Id, Name from Profile where Name='System Administrator'];
 
 User u =TestMethodUtility.createUser(p);
 insert u;
     
    Account ac =TestMethodUtility.createAccount(); 
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'India';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    
    insert c1;
    
    
   //core license 
    
   List<Core_License__c> lcr = new List<Core_License__c>();
   
    Core_License__c cr =TestMethodUtility.createCoreLicense();
    cr.Name = 'ANGEL';
    lcr.add(cr);
    
    Core_License__c cr2 =TestMethodUtility.createCoreLicense();
    cr2.Name = 'Learn';
    lcr.add(cr2);
    
    Core_License__c cr3 = TestMethodUtility.createCoreLicense();
    cr3.Name = 'CE/Vista';
    lcr.add(cr3);
    
    insert lcr;
     
     
     
   // Assets 
   list<asset> asset_list = new list<asset>();
    Asset aset = TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    asset_list.add(aset);
    
    Asset aset1 =TestMethodUtility.createAsset(ac,cr2);
    aset1.Name = 'Test Asset 111';
    aset1.Installed_Product_ID__c = '1234';
    aset1.Status = 'Installed'; 
    aset1.version__c = '9.1';
    aset1.Psft_Product_Id__c = 'AS-LS';
    aset1.Version_Build__c = '9.1.X';
    asset_list.add(aset1);
    
    Asset aset2 = TestMethodUtility.createAsset(ac,cr3);
    aset2.Name = 'Test Asset 111';
    aset2.Installed_Product_ID__c = '1235';
    aset2.Status = 'Installed'; 
    aset2.version__c = '9.1';
    aset2.Psft_Product_Id__c = 'AS-LS';
    aset2.Version_Build__c = '9.1.X';
    asset_list.add(aset2);
    
    insert asset_list;
    
  //////  
  set<id>caseidset=new set<id>();
  list<case> caselist = new list<case>();
    Case cassoftsol = new  case();      
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    caselist.add(cassoftsol);
   
  //case with Assets
     
  Case cassoftsol2 = TestMethodUtility.createCase1(ac,aset1);       
    cassoftsol2.ContactID = c1.ID;
    cassoftsol2.Case_Severity__c = '3';
    cassoftsol2.Subject = 'test';
    cassoftsol2.Description = 'test';
    caselist.add(cassoftsol2);
 
   
  /*  Case cassoftsol3 = TestMethodUtility.createCase1(ac,aset2);          
    cassoftsol3.ContactID = c1.ID;
    cassoftsol3.Case_Severity__c = '1';
    cassoftsol3.Subject = 'test';
    cassoftsol3.Description = 'test';
    caselist.add(cassoftsol3);*/
   
  
   insert caselist;
    caseidset.add(cassoftsol.ID);
    caseidset.add(cassoftsol2.ID);
//  caseidset.add(cassoftsol3.ID);

   
    list<Solution_Detail__c>  sol_list = new  list<Solution_Detail__c>();
        
    Solution_Detail__c sd = new Solution_Detail__c();
    sd.Case__c = cassoftsol.ID;
    sd.Status__c = 'In Consideration';
    sol_list.add(sd);
    
    Solution_Detail__c sd2 = new Solution_Detail__c();
    sd2.Case__c = cassoftsol2.ID;
    sd2.Status__c = 'In Consideration';
    sol_list.add(sd2);
    
/*    Solution_Detail__c sd3 = new Solution_Detail__c();
    sd3.Case__c = cassoftsol3.ID;
    sd3.Status__c = 'In Consideration';
    sol_list.add(sd3); */
    

     
     
     
     insert sol_list;
   
   List<Support_Workflow__c> sw = new List<Support_Workflow__c>();
    
    Support_Workflow__c sw1 = new Support_Workflow__c();
    sw1.Name='Close Case';
    sw1.Reply_Status_Update__c='Assigned';
    sw1.Reply_Portal_Status_Update__c='New';
    sw1.Close_Case_License__c='Transact';
    sw.add(sw1);
    
    
    Support_Workflow__c sw2 = new Support_Workflow__c();
    sw2.Name='Close Case';
    sw2.Reply_Status_Update__c='Assigned';
    sw2.Reply_Portal_Status_Update__c='New';
    sw2.Close_Case_License__c='Learn and ANGEL';
    sw.add(sw2);
    
    Support_Workflow__c sw3 = new Support_Workflow__c();
    sw3.Name='Close Case';
    sw3.Reply_Status_Update__c='Assigned';
    sw3.Reply_Portal_Status_Update__c='New';
    sw3.Close_Case_License__c='Xythos';
    sw.add(sw3);
    
    insert sw;
    
    String s='test';
    
    For(integer i=0 ;i<15 ;i++)
     s=s+s;
    
  map<id,case>casemap=new map<id,case>([select Id,CaseNumber from Case where ID in :caseidset]);
/*    Case cas1 = [select Id,CaseNumber from Case where ID =: cassoftsol.ID ];
    Case cas2 = [select Id,CaseNumber from Case where ID =: cassoftsol2.ID ];
    Case cas3 = [select Id,CaseNumber from Case where ID =: cassoftsol3.ID ];*/
//    Case cas4 = [select CaseNumber from Case where ID =: cassoftsol4.ID];
//    Case cas5 = [select CaseNumber from Case where ID =: cassoftsol5.ID];
 
      //below is for text Attachment
    
    Messaging.InboundEmail.TextAttachment inbTextAttchment = new Messaging.InboundEmail.TextAttachment();
    inbTextAttchment.body = 'Test Test Test Test Test Test Test Test Test';
    inbTextAttchment.fileName = 'myAttachment.txt';
    Messaging.InboundEmail.TextAttachment[] textAttachs = new Messaging.InboundEmail.TextAttachment[1];
    textAttachs[0] = inbTextAttchment;
    
  // below is for binary attachment
      
      Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
      Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
      binaryAttachment.Filename = 'test.txt';
      String algorithmName = 'HMacSHA1';
      Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
      Blob.valueOf('test_key'));
      binaryAttachment.Body = b;
      binaryAttachments[0] =  binaryAttachment ;
 
 
 

    Messaging.InboundEmail inemail = new Messaging.InboundEmail();
    inemail.fromAddress = 'prakashb6687@gmail.com';
    inemail.htmlBody = s;
    inemail.subject = 'Case CaseNumber : Case %' +casemap.get(cassoftsol.ID).CaseNumber+'%Need More Info%' + 'has been created';
    inemail.binaryAttachments = binaryAttachments ;
    inemail.textAttachments = textAttachs; 
    
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    env.fromAddress = 'prakashb6687@gmail.com';
    
    processEmailToCase emailtocase = new processEmailToCase();
    emailtocase.handleInboundEmail(inemail,env);
    test.starttest(); 
    cassoftsol.Status = 'Closed';
    Update cassoftsol;
    
 
  
    Messaging.InboundEmail inemail1 = new Messaging.InboundEmail();
    inemail1.fromAddress = 'prakashb6687@gmail.com';
    inemail1.htmlBody = 'hello';
    inemail1.subject = 'Case CaseNumber : Case %' +casemap.get(cassoftsol.ID).CaseNumber+'%Close Case%';
    inemail1.textAttachments = textAttachs; 
    inemail1.binaryAttachments = binaryAttachments ;
    
    Messaging.InboundEmail inemail2 = new Messaging.InboundEmail();
    inemail2.fromAddress = 'prakashb6687@gmail.com';
    inemail2.htmlBody = 'hello'  + s ;
   // inemail2.subject = 'Case CaseNumber : ';
    inemail2.subject ='Case CaseNumber : Case #' +casemap.get(cassoftsol2.ID).CaseNumber+'#Close case#' + 'has been created' ;
    inemail2.fromName='test Email';
    inemail2.fromAddress = 'prakashb6687@gmail.com';   
    inemail2.textAttachments = textAttachs; 
    inemail2.binaryAttachments = binaryAttachments ;
    
    Messaging.InboundEmail inemail3 = new Messaging.InboundEmail();
    inemail3.fromAddress = 'prakashb6687@gmail.com';
    inemail3.htmlBody = 'Case CaseNumber : Case %#' +casemap.get(cassoftsol.ID).CaseNumber+'%#Close case%#';
    inemail3.subject = 'Case CaseNumber : '+ 'has been created';
    inemail3.textAttachments = textAttachs; 
    inemail3.binaryAttachments = binaryAttachments ;
    
    Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
    env1.fromAddress = 'prakashb6687@gmail.com';

    processEmailToCase emailtocase1 = new processEmailToCase();
    
    emailtocase1.handleInboundEmail(inemail,env);

    emailtocase1.handleInboundEmail(inemail2,env);
   
    Test.stoptest(); 
    emailtocase1.handleInboundEmail(inemail3,env);
 

 
 }
 
 @isTest  static  void processEmailToCasetest1(){
 
 Profile p = [select Id, Name from Profile where Name='System Administrator'];
 
 User u =TestMethodUtility.createUser(p);
 insert u;
     
    Account ac = TestMethodUtility.createAccount(); 
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'India';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    
    insert c1;
    
   List<Core_License__c> lcr = new List<Core_License__c>();
    Core_License__c cr =TestMethodUtility.createCoreLicense();
    cr.Name = 'ANGEL';
    lcr.add(cr);
    
     Core_License__c cr2 = TestMethodUtility.createCoreLicense();
    cr2.Name = 'Learn';
     lcr.add(cr2);  
    
    Core_License__c cr3 = TestMethodUtility.createCoreLicense();
    cr3.Name = 'CE/Vista';
    lcr.add(cr3);
   
   insert lcr;
     
   // Assets 
   list<asset> asset_list = new list<asset>();
    Asset aset =TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    asset_list.add(aset);
    
    Asset aset1 = TestMethodUtility.createAsset(ac,cr2);
    aset1.Name = 'Test Asset 111';
    aset1.Installed_Product_ID__c = '1234';
    aset1.Status = 'Installed'; 
    aset1.version__c = '9.1';
    aset1.Psft_Product_Id__c = 'AS-LS';
    aset1.Version_Build__c = '9.1.X';
    asset_list.add(aset1);
    
    Asset aset2 = TestMethodUtility.createAsset(ac,cr3);
    aset2.Name = 'Test Asset 111';
    aset2.Installed_Product_ID__c = '1235';
    aset2.Status = 'Installed'; 
    aset2.version__c = '9.1';
    aset2.Psft_Product_Id__c = 'AS-LS';
    aset2.Version_Build__c = '9.1.X';
    asset_list.add(aset2);
    
    insert asset_list;
    
  //////  
   set<id>caseidset=new set<id>();
  list<case> caselist = new list<case>();
    Case cassoftsol = new Case();        
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    
    caselist.add(cassoftsol);
  
  //case with Assets
     
  Case cassoftsol2 = TestMethodUtility.createCase1(ac,aset1);         
    cassoftsol2.ContactID = c1.ID;
    cassoftsol2.Case_Severity__c = '3';
    cassoftsol2.Subject = 'test';
    cassoftsol2.Description = 'test';
 caselist.add(cassoftsol2);
   
    Case cassoftsol3 = TestMethodUtility.createCase1(ac,aset2);    
    cassoftsol3.ContactID = c1.ID;
    cassoftsol3.Case_Severity__c = '1';
    cassoftsol3.Subject = 'test';
    cassoftsol3.Description = 'test';
  caselist.add(cassoftsol3);
     
  
  insert caselist;
  caseidset.add(cassoftsol.ID);
    caseidset.add(cassoftsol2.ID);
 caseidset.add(cassoftsol3.ID);

   
    list<Solution_Detail__c>  sol_list = new  list<Solution_Detail__c>();
        
    Solution_Detail__c sd = new Solution_Detail__c();
    sd.Case__c = cassoftsol.ID;
    sd.Status__c = 'In Consideration';
    sol_list.add(sd);
    
    Solution_Detail__c sd2 = new Solution_Detail__c();
    sd2.Case__c = cassoftsol2.ID;
    sd2.Status__c = 'In Consideration';
    sol_list.add(sd2);
    
    Solution_Detail__c sd3 = new Solution_Detail__c();
    sd3.Case__c = cassoftsol3.ID;
    sd3.Status__c = 'In Consideration';
    sol_list.add(sd3);
    

     
     
     
     insert sol_list;
   
   List<Support_Workflow__c> sw = new List<Support_Workflow__c>();
    
    Support_Workflow__c sw1 = new Support_Workflow__c();
    sw1.Name='Close Case';
    sw1.Reply_Status_Update__c='Assigned';
    sw1.Reply_Portal_Status_Update__c='New';
    sw1.Close_Case_License__c='Transact';
    sw.add(sw1);
    
    
    Support_Workflow__c sw2 = new Support_Workflow__c();
    sw2.Name='Close Case';
    sw2.Reply_Status_Update__c='Assigned';
    sw2.Reply_Portal_Status_Update__c='New';
    sw2.Close_Case_License__c='Learn and ANGEL';
    sw.add(sw2);
    
    Support_Workflow__c sw3 = new Support_Workflow__c();
    sw3.Name='Close Case';
    sw3.Reply_Status_Update__c='Assigned';
    sw3.Reply_Portal_Status_Update__c='New';
    sw3.Close_Case_License__c='Xythos';
    sw.add(sw3);
    
    insert sw;
    
    
   // this has been done to make string size 32000 
    String s='test';
    
    For(integer i=0 ;i<15 ;i++)
     s=s+s;
   
  // since case number is auto number so query it 
   map<id,case>casemap=new map<id,case>([select Id,CaseNumber from Case where ID in :caseidset]); 
 /*   Case cas1 = [select Id,CaseNumber from Case where ID =: cassoftsol.ID ];
    Case cas2 = [select Id,CaseNumber from Case where ID =: cassoftsol2.ID ];
    Case cas3 = [select Id,CaseNumber from Case where ID =: cassoftsol3.ID ];*/

 
    Messaging.InboundEmail.TextAttachment inbTextAttchment = new Messaging.InboundEmail.TextAttachment();
    inbTextAttchment.body = 'Test Test Test Test Test Test Test Test Test';
    inbTextAttchment.fileName = 'myAttachment.txt';
    Messaging.InboundEmail.TextAttachment[] textAttachs = new Messaging.InboundEmail.TextAttachment[1];
    textAttachs[0] = inbTextAttchment;
 
 
 // below is for binary attachment
      
      Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
      Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
      binaryAttachment.Filename = 'test.txt';
      String algorithmName = 'HMacSHA1';
      Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
      Blob.valueOf('test_key'));
      binaryAttachment.Body = b;
      binaryAttachments[0] =  binaryAttachment ;
 

    Messaging.InboundEmail inemail = new Messaging.InboundEmail();
    inemail.fromAddress = 'prakashb6687@gmail.com';
    inemail.htmlBody = s;
    inemail.subject = 'Case CaseNumber : Case %' + casemap.get(cassoftsol.ID).CaseNumber+'%Need More Info%' + 'has been created';
    inemail.textAttachments = textAttachs;
    inemail.binaryAttachments = binaryAttachments ;
    
    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    env.fromAddress = 'prakashb6687@gmail.com';
    
    processEmailToCase emailtocase = new processEmailToCase();
    emailtocase.handleInboundEmail(inemail,env);
    test.starttest(); 
    cassoftsol.Status = 'Closed';
    Update cassoftsol;
    
  
    Messaging.InboundEmail inemail1 = new Messaging.InboundEmail();
    inemail1.fromAddress = 'prakashb6687@gmail.com';
    inemail1.plaintextBody = 'Case CaseNumber : Case #' + casemap.get(cassoftsol2.ID).CaseNumber+'#Close case#' + s;
    inemail1.subject ='Case CaseNumber : Case #' + casemap.get(cassoftsol2.ID).CaseNumber+'#Close case#' + 'has been created' ;
    inemail1.fromName='test Email1';
    inemail1.fromAddress = 'prakashb6687@gmail.com';
    inemail1.textAttachments = textAttachs;
    inemail1.binaryAttachments = binaryAttachments ;
    
    Messaging.InboundEmail inemail2 = new Messaging.InboundEmail();
    inemail2.fromAddress = 'prakashb6687@gmail.com';
    inemail2.subject ='Case CaseNumber : Case #' + casemap.get(cassoftsol2.ID).CaseNumber+'#Close case#' ;
    inemail2.fromName='test Email';
    inemail2.fromAddress = 'prakashb6687@gmail.com';
    inemail2.plaintextBody = 'Case CaseNumber : Case %#' + casemap.get(cassoftsol2.ID).CaseNumber+'%#Close case%#' + s;
    inemail2.textAttachments = textAttachs;
    inemail2.binaryAttachments = binaryAttachments ;
    
    Messaging.InboundEmail inemail3 = new Messaging.InboundEmail();
    inemail3.fromAddress = 'prakashb6687@gmail.com';
  //inemail3.htmlBody = 'Case CaseNumber : Case %#' + cas1.CaseNumber+'%#Close case%#';
    inemail3.subject = 'Case CaseNumber : ' ;

     
    Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
    env1.fromAddress = 'prakashb6687@gmail.com';

    processEmailToCase emailtocase1 = new processEmailToCase();
    
    emailtocase1.handleInboundEmail(inemail1,env);

    emailtocase1.handleInboundEmail(inemail2,env);
   
    Test.stoptest(); 
    emailtocase1.handleInboundEmail(inemail3,env);
 

 
 }
}