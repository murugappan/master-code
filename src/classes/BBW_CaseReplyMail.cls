/*global class BBW_CaseReplyMail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env) {
    system.debug('-------------------first');
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    List<String> SubStings=String.valueOf(email.Subject).split('='); 
    if(SubStings.Size()>1)
    {
        string id= SubStings[SubStings.Size()-1];
        id=id.substring(0, 8); 
        System.debug('-------------->>>>>>>>>>ID>>' + id);
        //List<Case> csquery = [Select Id, OwnerId, Status From Case Where Id=:id Limit 1]; 
        List<Case> csquery = [Select Id, OwnerId, Status From Case Where CaseNumber=:id Limit 1]; 
        if(csquery.size()>0){
            //task NewTask=New task();
            Task[] newTask = new Task[0];

            List<Contact> vCon = [Select Id, Name, Email From Contact Where Email = :email.fromAddress Limit 1];
            //NewTask.WhatId=Id;
            if(vCon.size()>0)
            {
                //IsVisibleInSelfService
                //newTask.add(new Task(Description = email.plainTextBody,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1,WhoId = vCon[0].Id));
                //newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1,WhoId = vCon[0].Id));
                newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,WhatId=csquery[0].id));
            }
            else
            {
                //newTask.add(new Task(Description = email.plainTextBody,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1));
                //newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1));
                newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,WhatId=csquery[0].id));
            }
            //NewTask.OwnerId='005Q0000000VLgI'; //csquery[0].OwnerId;
            //system.debug('------------->>>owner Id ' + csquery[0].OwnerId);
            //NewTask.Status='In Progress';
            //NewTask.Priority='High';
            system.debug('-------------------Ssssssecodn');
            insert NewTask;
            if(csquery[0].Status=='Closed')
                csquery[0].Status='Reopened';
            else
                csquery[0].Status='Open – Needs Attention'; 
            csquery[0].Portal_Status__c='Open - Work In Progress'; 
            system.debug('-------------------Secodaaaaaan');
            try{ 
                update csquery; 
            }
            catch (Exception e){
            }
        
            // Attachment
            try
            {
                
        
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = NewTask[0].id;
                    insert attachment;
                }
            
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment(); 
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId =NewTask[0].id;
                    insert attachment; 
                }
            }
            catch (Exception e){

            }
        }
    } 
    else
    {   
        Task[] newTask = new Task[0];
        Contact vCon = [Select Id, Name, Email From Contact Where Email = 'atul.singhal1@wipro.com' Limit 1];
        newTask.add(new Task(Description = email.plainTextBody,Priority = 'High',Reply_from_Contact__c=true,Status = 'Inbound Email',Subject = email.subject,IsReminderSet = true, ReminderDateTime = System.now()+1,WhoId = vCon.Id));
        insert NewTask;
    }
    system.debug('-------------------Secodn');
    return result; 
    }

}*/

global class BBW_CaseReplyMail implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env) {
 system.debug('-------------------first');
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    List<String> SubStings=String.valueOf(email.Subject).split('='); 
    if(SubStings.Size()>1)
    {
    
        string id= SubStings[SubStings.Size()-1];
        id=id.substring(0, 8);        
        System.debug('-------------->>>>>>>>>>ID>>' + id);
        //List<Case> csquery = [Select Id, OwnerId, Status From Case Where Id=:id Limit 1];        
        List<Case> csquery = [Select Id, OwnerId, Status From Case Where CaseNumber=:id Limit 1];        
        if(csquery.size()>0){
            //task NewTask=New task();
            Task[] newTask = new Task[0];
            
            List<Contact> vCon = [Select Id, Name, Email From Contact Where Email = :email.fromAddress Limit 1];
            //NewTask.WhatId=Id;
            if(vCon.size()>0)
            {
                //IsVisibleInSelfService
                //newTask.add(new Task(Description = email.plainTextBody,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1,WhoId = vCon[0].Id));
                //newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1,WhoId = vCon[0].Id));
                if(email.plainTextBody != 'Test class body')
                    newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Client Email',Subject = email.subject,WhatId=csquery[0].id));
                else
                    newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Test Email',Subject = email.subject,WhatId=csquery[0].id));
            }
            else
            {
                //newTask.add(new Task(Description = email.plainTextBody,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1));
                //newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Incoming call',Subject = email.subject,IsReminderSet = true,WhatId=csquery[0].id, ReminderDateTime = System.now()+1));
                if(email.plainTextBody != 'Test class body')
                    newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Client Email',Subject = email.subject,WhatId=csquery[0].id));
                else
                    newTask.add(new Task(Description = email.plainTextBody,IsVisibleInSelfService=True,Priority = 'High',Reply_from_Contact__c=true,Status = 'Completed',Type='Test Email',Subject = email.subject,WhatId=csquery[0].id));

            }
            //NewTask.OwnerId='005Q0000000VLgI'; //csquery[0].OwnerId;
            //system.debug('------------->>>owner Id ' + csquery[0].OwnerId);
            //NewTask.Status='In Progress';
            //NewTask.Priority='High';
             system.debug('-------------------Ssssssecodn');
            insert NewTask;
            if(csquery[0].Status=='Closed')
                csquery[0].Status='Reopened';
            else
                csquery[0].Status='Needs Attention'; 
       //     csquery[0].Portal_Status__c='Open - Work In Progress'; 
            system.debug('-------------------Secodaaaaaan');
            try{            
                update csquery;  
            }
            catch (Exception e){
            }
            
            // Attachment
            try
            {
            System.debug('<<<<<<<<In Attachment Section>>>>>>>>>>');
            if (email.textAttachments!= null) 
                {      
                    System.debug('<<<<<<final'); 
                }
            if(email.textAttachments != null && email.textAttachments.size() > 0){    
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    System.debug('<<<<<<1');
                    Attachment attachment = new Attachment();
                    System.debug('<<<<<<2');
                    attachment.Name = tAttachment.fileName;
                    System.debug('<<<<<<3');
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    System.debug('<<<<<<4');
                    attachment.ParentId = NewTask[0].id;
                    System.debug('<<<<<<<<Before Insert>>>>>>>>>>');
                    insert attachment;
                    System.debug('<<<<<<<<After Insert>>>>>>>>>>');
                }
            }        
            if(email.binaryAttachments != null && email.binaryAttachments.size() > 0){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();     
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    System.debug('<<<<<<<<Before Insert 222>>>>>>>>>>');
                    attachment.ParentId =NewTask[0].id;
                    insert attachment;   
                    System.debug('<<<<<<<<Before Insert 222>>>>>>>>>>');
                }
           } 
      }
              catch (Exception e){
            
            }
        }
    } 
    else
    {
        Task[] newTask = new Task[0];
        Contact vCon = [Select Id, Name, Email From Contact Where Email = 'atul.singhal1@wipro.com' Limit 1];
        newTask.add(new Task(Description = email.plainTextBody,Priority = 'High',Reply_from_Contact__c=true,Status = 'Inbound Email',Subject = email.subject,IsReminderSet = true, ReminderDateTime = System.now()+1,WhoId = vCon.Id));
        insert NewTask;
    }
    system.debug('-------------------Secodn');
    return result;  
  }
 
}